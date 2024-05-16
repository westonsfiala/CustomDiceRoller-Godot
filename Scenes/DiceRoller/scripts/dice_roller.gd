extends Control
class_name DiceRoller

@onready var top_edge : StaticBody2D = $TopEdge
@onready var right_edge : StaticBody2D = $RightEdge
@onready var bottom_edge : StaticBody2D = $BottomEdge
@onready var left_edge : StaticBody2D = $LeftEdge

@onready var instruction_label : Label = $InstructionLabel
@onready var go_to_results_button : LongPressButton = $MarginContainer/GoToResultsButton

@onready var tap_timeout_timer : Timer = $TapTimeoutTimer
@onready var hold_timeout_timer : Timer = $HoldTimeoutTimer
@onready var done_timeout_timer : Timer = $DoneTimeoutTimer

enum shake_state {SHAKE, HOLD, DONE}
var state : shake_state = shake_state.SHAKE

const tap_instruction_text : String = "Tap!"
const shake_instruction_text : String = "Shake!"
const hold_instruction_text : String = "Hold Still"
const done_instruction_text : String = "Done"

const extra_bumper_space : int = 300
const bumper_thickness : int = 500
const half_bumper_thickness: int = int(bumper_thickness / 2.0)

var num_taps: int = 0
const NEEDED_TAPS: int = 3
const TAP_TIMEOUT_TIME: int = 5
const HOLD_TIMEOUT_TIME: int = 2
const DONE_TIMEOUT_TIME: float = 0.25

var stored_roll_results: RollResults = RollResults.new()
var physics_dice_array: Array[PhysicsDice] = []

signal finished_animated_roll(roll_results: RollResults)

# Set up the roller with the roll it will be animating
func configure(roll_results: RollResults) -> void:
	stored_roll_results = roll_results
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_shake_state(shake_state.SHAKE)
	num_taps = 0
	physics_dice_array = []
	
	SettingsManager.window_size_changed.connect(go_to_results_page)
	setup_bumpers()
	
	var window_size : Vector2 = SettingsManager.get_window_size()
	# If we have too many dice in the roll it isn't very fun.
	# Only allow up to half of the screen to be filled with dice.
	var screen_area: float = int(window_size.x * window_size.y)
	var die_size: float = SettingsManager.get_dice_size()
	var die_area: float = die_size * die_size
	var max_allowed_dice_float: float = screen_area / die_area / 2
	var max_allowed_dice: int = int(max_allowed_dice_float)
	
	# Go through and calculate how many dice there should be.
	var total_dice: int = 0
	var onscreen_dice: int = 0
	var dice_dict: Dictionary = {}
	for prop_pair : DiePropertyPair in stored_roll_results.stored_roll.m_die_prop_array:
		var die : AbstractDie = prop_pair.m_die
		var properties : RollProperties = prop_pair.m_roll_properties
		var num_dice : int = properties.get_num_dice() * properties.get_repeat_roll()
		if properties.is_advantage() or properties.is_disadvantage():
			num_dice *= 2
		dice_dict[die] = num_dice
		total_dice += num_dice
	
	# If we have too many dice, modify it down to the correct amount.
	if total_dice > max_allowed_dice:
		var adjust_ratio: float = float(max_allowed_dice) / total_dice
		for key : AbstractDie in dice_dict.keys():
			var num_dice : int = int(dice_dict[key] * adjust_ratio)
			dice_dict[key] = num_dice
			onscreen_dice += num_dice
	else:
		onscreen_dice = total_dice
	
	# Put some number of dice into the screen
	for die : AbstractDie in dice_dict:
		for count : int in dice_dict[die]:
			var physics_dice_node: PhysicsDice = preload("res://Scenes/DiceRoller/physics_dice.tscn").instantiate()
			physics_dice_node.configure(die)
			physics_dice_node.set_index(count, onscreen_dice)
			physics_dice_array.push_back(physics_dice_node)
			add_child(physics_dice_node)
			
# Sets up all the bouncer bars 
func setup_bumpers() -> void:
	var button_size: int = SettingsManager.get_button_size()
	
	# Set the button size.
	go_to_results_button.custom_minimum_size.y = button_size
	
	var half_screen_size : Vector2 = size / 2.0
	
	# Apply the sizes and place all the bumpers
	top_edge.position = Vector2(half_screen_size.x, 0)
	right_edge.position = Vector2(size.x, half_screen_size.y)
	bottom_edge.position = Vector2(half_screen_size.x, size.y )
	left_edge.position = Vector2(0, half_screen_size.y)

# While we are waiting for the taps, keep processing.
func _process(_delta: float) -> void:
	match state:
		shake_state.SHAKE:
			if(num_taps >= NEEDED_TAPS):
				set_shake_state(shake_state.HOLD)
		
# Set the shake state and adjust the text in the middle of screen.
func set_shake_state(new_state: shake_state) -> void:
	# Stop any timers that are still going so we don't get a timeout signal from them.
	tap_timeout_timer.stop()
	hold_timeout_timer.stop()
	done_timeout_timer.stop()
	
	# Set the new state and start the appropriate timer.
	state = new_state
	match state:
		shake_state.SHAKE:
			instruction_label.text = tap_instruction_text
			tap_timeout_timer.start(TAP_TIMEOUT_TIME)
		shake_state.HOLD:
			instruction_label.text = hold_instruction_text
			hold_timeout_timer.start(HOLD_TIMEOUT_TIME)
			for physics_die : PhysicsDice in physics_dice_array:
				physics_die.linear_damp = 2
				physics_die.angular_damp = 2
				physics_die.gravity_scale = 0
		shake_state.DONE:
			instruction_label.text = done_instruction_text
			done_timeout_timer.start(DONE_TIMEOUT_TIME)
			for physics_die : PhysicsDice in physics_dice_array:
				physics_die.freeze = true

# Press the button, resize the window, or finish the final timer, leave the scene.
func go_to_results_page() -> void:
	emit_signal("finished_animated_roll", stored_roll_results)

# Count the number of taps.
func _on_background_button_pressed() -> void:
	num_taps += 1

# When tap timeout occurs, go to hold.
func _on_tap_timeout_timer_timeout() -> void:
	set_shake_state(shake_state.HOLD)

# When hold timeout occurs, go to done.
func _on_hold_timeout_timer_timeout() -> void:
	set_shake_state(shake_state.DONE)

# Unfreeze all the dice after a short delay.
# If we don't do this, some weird flash appears on screen.
func _on_initial_unfreeze_timer_timeout() -> void:
	for die : PhysicsDice in physics_dice_array:
		die.freeze = false
		die.launch_die_randomly()
