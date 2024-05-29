extends HBoxContainer
class_name UpDownButtons

@export var m_prefix : String
@export var m_postfix : String
@export var m_show_plus_minus : bool
@export var m_disallow_zero : bool

@onready var down_button : LongPressButton = $DownButton
@onready var value_text_button : SettingsManagedTextButton = $ValueTextButton
@onready var up_button : LongPressButton = $UpButton

var m_value : int = 0

signal value_pressed()
signal value_changed(value: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SettingsManager.button_size_changed.connect(reconfigure)
	set_value(m_value)
	reconfigure()
	
func setup_exports(prefix: String, postfix: String, show_plus_minus: bool, disallow_zero: bool) -> void:
	m_prefix = prefix
	m_postfix = postfix
	m_show_plus_minus = show_plus_minus
	m_disallow_zero = disallow_zero
	set_value(m_value)

func reconfigure() -> void:
	pass
	
func get_value() -> int:
	return m_value
	
func set_value(value : int) -> void:
	var current_value : int = m_value
	m_value = enforce_good_value(value, 0)
	var tween : Tween = get_tree().create_tween()
	
	var tween_duration : float = min(SettingsManager.LONG_PRESS_DELAY, 0.01 * abs(current_value - m_value))
	tween.tween_method(set_value_text, current_value, m_value, tween_duration)
	
func set_value_text(value: int) -> void:
	var new_text : String = str(value)
	if(m_show_plus_minus):
		new_text = StringHelper.get_modifier_string(value, false)
	value_text_button.text = m_prefix + new_text + m_postfix
	
func handle_change(change: int) -> void:
	var snapped_change : int = snap_to_next_increment(m_value, change)
	var new_value : int = enforce_good_value(m_value, snapped_change)
	emit_signal("value_changed", new_value)
	
# Sometimes we do not want to allow for the value to be 0.
func enforce_good_value(value: int, change: int) -> int:
	var new_value : int = value + change;
	
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
		
	var value_rem : int = value_in % step_size

	# If you are negative jumping up, or positive jumping down, just drop down/up the remainder.
	if((value_rem > 0 and step_size < 0) or (value_rem < 0 and step_size > 0)):
		return -value_rem
	else:
		return -value_rem + step_size

# Decrement when pressed
func _on_down_button_short_pressed() -> void:
	handle_change(-1)

func _on_down_button_long_pressed() -> void:
	handle_change(-100)

func _on_up_button_short_pressed() -> void:
	handle_change(1)

func _on_up_button_long_pressed() -> void:
	handle_change(100)

func _on_value_text_button_pressed() -> void:
	emit_signal("value_pressed")
