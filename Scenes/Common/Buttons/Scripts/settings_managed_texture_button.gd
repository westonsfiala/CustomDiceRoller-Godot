extends Button

@export var texture_2d : Texture2D = preload("res://Icons/CircleCancel.svg")

@onready var margin_container : MarginContainer = $MarginContainer
@onready var texture_rect : TextureRect = $MarginContainer/TextureRect
@onready var long_press_timer : Timer = $LongPressTimer

signal long_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_rect.texture = texture_2d
	SettingsManager.reconfigure.connect(reconfigure)
	call_deferred("reconfigure")
	
# Reconfigures the scene according to the settings
func reconfigure():
	print("reconfiguring texture button")
	var button_size = SettingsManager.get_button_size()
	var margin_padding = SettingsManager.get_margin_padding()
	custom_minimum_size = Vector2.ONE * button_size
	
	add_theme_constant_override("margin_top", margin_padding)
	add_theme_constant_override("margin_left", margin_padding)
	add_theme_constant_override("margin_bottom", margin_padding)
	add_theme_constant_override("margin_right", margin_padding)

# Start the timer when we press down
func _on_button_down():
	print("button down")
	long_press_timer.start(0.3)

# Stop the timer if we don't time out before the button comes up
func _on_button_up():
	if(not long_press_timer.is_stopped()):
		long_press_timer.stop()
	
func _on_long_press_timer_timeout():
	print("long press detected")
	long_press_timer.stop()
	emit_signal("long_pressed")
