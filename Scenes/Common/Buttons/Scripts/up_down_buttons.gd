extends HBoxContainer
class_name UpDownButtons

@export var m_display_title : StringName
@export var m_prefix : String
@export var m_postfix : String
@export var m_show_plus_minus : bool
@export var m_disallow_zero : bool

@onready var down_button : LongPressButton = $DownButton
@onready var value_text_button : SettingsManagedTextButton = $ValueTextButton
@onready var up_button : LongPressButton = $UpButton
@onready var set_value_exact_popup : SetValueExactPopup = $SetValueExactPopup

var m_value : int = 0
var m_text_value : int = 0
var m_tween : Tween = null

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
	
# Gets the exact value of the button.
func get_value() -> int:
	return m_value

# Set the value of the button. Will tween the text to the new value.
func set_value(value : int) -> void:
	m_value = enforce_good_value(value, 0)

	if m_tween:
		m_tween.kill()
	m_tween = get_tree().create_tween()
	
	var tween_duration : float = min(SettingsManager.LONG_PRESS_DELAY, 0.01 * abs(m_text_value - m_value))
	m_tween.tween_method(set_value_text, m_text_value, m_value, tween_duration)

# Helper function to set the text of the value button. Don't call directly.
func set_value_text(value: int) -> void:
	m_text_value = value
	var new_text : String = str(value)
	if(m_show_plus_minus):
		new_text = StringHelper.get_modifier_string(value, false)
	value_text_button.text = m_prefix + new_text + m_postfix

# Handles a change from one of the button presses.
func handle_change(change: int) -> void:
	var snapped_change : int = snap_to_next_increment(m_value, change)
	var new_value : int = enforce_good_value(m_value, snapped_change)
	set_value(new_value)
	emit_signal("value_changed", m_value)

# Handles the change when set exactly.
func handle_exact_change(value: int) -> void:
	var new_value : int = enforce_good_value(value, 0)
	set_value(new_value)
	emit_signal("value_changed", m_value)
	
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
	set_value_exact_popup.set_initial_value(m_display_title, m_value)
	set_value_exact_popup.modular_popup_center()

# When the user has entered a new value from the popup
func _on_set_value_exact_popup_value_changed(value: int) -> void:
	handle_exact_change(value)
