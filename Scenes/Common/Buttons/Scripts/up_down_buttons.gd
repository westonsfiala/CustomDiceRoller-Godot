extends Control

@export var postfix : String
@export var show_plus_minus : bool
@export var disallow_zero : bool

@onready var down_button : Button = $HBoxContainer/DownButton
@onready var label : Label = $HBoxContainer/ValueLabel
@onready var up_button : Button = $HBoxContainer/UpButton

var m_value : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SettingsManager.reconfigure.connect(deferred_reconfigure)
	deferred_reconfigure()
	
func deferred_reconfigure():
	call_deferred("reconfigure")

func reconfigure():
	print("reconfiguring up down buttons")
	var button_size = SettingsManager.get_button_size()
	custom_minimum_size = Vector2(0, button_size)
	
	m_value = enforce_good_value(m_value, 0)
	var new_text = str(m_value)
	if(show_plus_minus):
		new_text = StringHelper.get_modifier_String(m_value, show_plus_minus)
		
	label.text = new_text + postfix
	
func get_value() -> int:
	return m_value
	
func set_value(value : int):
	m_value = value
	reconfigure()
	
func handle_change(change: int):
	var snapped_change = snap_to_next_increment(m_value, change)
	var new_value = enforce_good_value(m_value, snapped_change)
	set_value(new_value)
	
# Sometimes we do not want to allow for the value to be 0.
func enforce_good_value(value: int, change: int):
	var new_value = value + change;
	
	# If we aren't zero or care about not being zero, your good!
	if(new_value != 0 or not disallow_zero):
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
func _on_down_button_pressed():
	handle_change(-1)

func _on_down_button_button_down():
	pass # Replace with function body.

# Increment when pressed
func _on_up_button_pressed():
	handle_change(1)
