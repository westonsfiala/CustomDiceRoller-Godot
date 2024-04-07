extends Control

@onready var press_response_image : TextureRect = $PressResponseImage
@onready var resize_timer : Timer = $ResizeTimer

var tween : Tween
var last_click_position : Vector2

var animated_roller: DiceRoller = null
var full_screen_results: FullScreenResult = null

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().size_changed.connect(start_resize_timer)
	resize_timer.timeout.connect(SettingsManager.trigger_window_size_change)
	SettingsManager.button_size_changed.connect(reconfigure)
	SettingsManager.mouse_unpress.connect(fake_unpress)
	RollManager.new_roll_result.connect(process_new_roll)
	reconfigure()

func reconfigure():
	press_response_image.size = Vector2.ONE * SettingsManager.get_button_size()
	press_response_image.pivot_offset = press_response_image.size / 2
	
func start_resize_timer() -> void:
	resize_timer.start(SettingsManager.LONG_PRESS_DELAY)
	
# Special method used to trigger a mouse unpress event.
# The game state can get weird when you do popups and it can get
# locked in a state of thinking its pressed.
func fake_unpress():
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		var unpress_event = InputEventMouseButton.new()
		unpress_event.position = get_global_mouse_position()
		unpress_event.button_index = MOUSE_BUTTON_LEFT
		unpress_event.pressed = false
		get_viewport().push_input(unpress_event)

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if(event.is_pressed()):
				respond_to_press()
			else:
				respond_to_unpress()
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if last_click_position:
			var move_length = (last_click_position - get_global_mouse_position()).length()
			if move_length > 5:
				respond_to_unpress()
			
func respond_to_press():
	if tween:
		tween.kill() 
	last_click_position = get_global_mouse_position()
	tween = get_tree().create_tween()
	press_response_image.visible = true
	press_response_image.scale = Vector2.ZERO
	press_response_image.rotation_degrees = -360
	press_response_image.position = last_click_position - press_response_image.pivot_offset
	tween.set_parallel()
	tween.tween_property(press_response_image, "rotation_degrees", 360, SettingsManager.LONG_PRESS_DELAY)
	tween.tween_property(press_response_image, "scale", Vector2.ONE, SettingsManager.LONG_PRESS_DELAY)
	
func respond_to_unpress() -> void:
	if press_response_image.scale == Vector2.ZERO:
		return
	if tween:
		tween.kill() 
	tween = get_tree().create_tween()
	tween.tween_property(press_response_image, "scale", Vector2.ZERO, SettingsManager.LONG_PRESS_DELAY / 2)
	tween.tween_property(press_response_image, "visible", false, 0)
	last_click_position = Vector2.ZERO
	
func process_new_roll(roll_results: RollResults):
	if SettingsManager.animations_enabled:
		create_animated_roller(roll_results)
	else:
		create_roll_results_screen(roll_results)
	
func create_animated_roller(roll_results: RollResults):
	animated_roller = preload("res://Scenes/DiceRoller/dice_roller.tscn").instantiate()
	animated_roller.configure(roll_results)
	animated_roller.finished_animated_roll.connect(create_roll_results_screen)
	add_child(animated_roller)
	
func destroy_animated_roller():
	if animated_roller:
		animated_roller.queue_free()
		animated_roller = null
	
func create_roll_results_screen(roll_results: RollResults):
	destroy_animated_roller()
	full_screen_results = preload("res://Scenes/DiceRoller/full_screen_result.tscn").instantiate()
	full_screen_results.configure(roll_results)
	full_screen_results.finished.connect(destroy_roll_results_screen)
	full_screen_results.reroll.connect(reroll_from_roll_results_screen)
	add_child(full_screen_results)
	
func reroll_from_roll_results_screen(roll_results: RollResults):
	destroy_roll_results_screen()
	RollManager.reroll_from_results(roll_results)
	
func destroy_roll_results_screen():
	if full_screen_results:
		full_screen_results.queue_free()
		full_screen_results = null


