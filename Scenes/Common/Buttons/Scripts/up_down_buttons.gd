extends Control
class_name UpDownButtons

@export var m_prefix : String
@export var m_postfix : String
@export var m_show_plus_minus : bool
@export var m_disallow_zero : bool

@onready var margin_container : MarginContainer = $MarginContainer
@onready var down_button : LongPressButton = $MarginContainer/HBoxContainer/DownButton
@onready var value_text_button : SettingsManagedTextButton = $MarginContainer/HBoxContainer/ValueTextButton
@onready var up_button : LongPressButton = $MarginContainer/HBoxContainer/UpButton

var m_value : int = 0

signal value_pressed()
signal value_changed(value: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	SettingsManager.reconfigure.connect(deferred_reconfigure)
	set_value(m_value)
	deferred_reconfigure()
	
func deferred_reconfigure():
	call_deferred("reconfigure")
	
func setup_exports(prefix: String, postfix: String, show_plus_minus: bool, disallow_zero: bool):
	m_prefix = prefix
	m_postfix = postfix
	m_show_plus_minus = show_plus_minus
	m_disallow_zero = disallow_zero
	set_value(m_value)

func reconfigure():
	print("reconfiguring up down buttons")
	var button_size = SettingsManager.get_button_size()
	var margin_size = margin_container.get_theme_constant("margin_top") + margin_container.get_theme_constant("margin_bottom")
	custom_minimum_size = Vector2(0, button_size + margin_size)
	
func get_value() -> int:
	return m_value
	
func set_value(value : int):
	var current_value = m_value
	m_value = enforce_good_value(value, 0)
	var tween = get_tree().create_tween()
	
	var tween_duration = min(SettingsManager.LONG_PRESS_DELAY, 0.01 * abs(current_value - m_value))
	tween.tween_method(set_value_text, current_value, m_value, tween_duration)
	
func set_value_text(value: int):
	var new_text = str(value)
	if(m_show_plus_minus):
		new_text = StringHelper.get_modifier_string(value, false)
	value_text_button.text = m_prefix + new_text + m_postfix
	
func handle_change(change: int):
	var snapped_change = snap_to_next_increment(m_value, change)
	var new_value = enforce_good_value(m_value, snapped_change)
	emit_signal("value_changed", new_value)
	
# Sometimes we do not want to allow for the value to be 0.
func enforce_good_value(value: int, change: int):
	var new_value = value + change;
	
	# If we aren't zero or care about not being zero, your good!
	if(new_value != 0 or not m_disallow_zero):
		return new_value
	
	# Skip over 0 when we are incrememting
	if(value < -1 and change > 1):
		return -1
	
	# Skip over 0 when we are decrementing
	if(value > 1 && change < -1):
		return 1
	
	if(change >= 0):
		return 1

	return -1

# Will return the increment that is needed to snap to the next evenly divisible stepSize.
# i.e (101, 100) -> 99, (101,-100) -> -1
func snap_to_next_increment(value_in: int, step_size: int) -> int:
	if(step_size == 0):
		return value_in
		
	var value_rem = value_in % step_size

	# If you are negative jumping up, or positive jumping down, just drop down/up the remainder.
	if((value_rem > 0 and step_size < 0) or (value_rem < 0 and step_size > 0)):
		return -value_rem
	else:
		return -value_rem + step_size

# Decrement when pressed
func _on_down_button_short_pressed():
	handle_change(-1)

func _on_down_button_long_pressed():
	handle_change(-100)

func _on_up_button_short_pressed():
	handle_change(1)

func _on_up_button_long_pressed():
	handle_change(100)

func _on_value_text_button_pressed():
	emit_signal("value_pressed")
