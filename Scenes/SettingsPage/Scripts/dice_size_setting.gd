extends CollapsibleSettingBase
class_name DiceSizeSetting

@onready var die_size_slider : HSlider = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/DieSizeSlider

const DIE_SIZE_LABEL_TEXT : String = "Size - "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SettingsManager.window_size_changed.connect(reconfigure_slider)
	SettingsManager.dice_size_changed.connect(reconfigure_slider)
	reconfigure_slider()
	
# Reconfigures the slider and its maximum value to be half the screen width
func reconfigure_slider() -> void:
	var window_size : Vector2 = SettingsManager.get_window_size()
	# Only let dice size be half the window size, minus a bit to make it so 
	# you can have side by side dice in the simple roll view
	die_size_slider.max_value = min(window_size.x, window_size.y)/2 - 10
	
	# Set the text and the current slider value.
	# If the max is smaller than our current value, lower our current value.
	var new_size : int = SettingsManager.get_dice_size()
	if new_size > die_size_slider.max_value:
		new_size = int(die_size_slider.max_value)
		die_size_slider.value = new_size
	die_size_slider.set_value_no_signal(new_size)
	set_title()
	
	show_hide_reset_button()
	
# Called as the slider is being adjusted
func _on_die_size_slider_value_changed(_value: int) -> void:
	SettingsManager.set_dice_size(int(die_size_slider.value))
	emit_signal("setting_changed")
	
func inner_get_title() -> String:
	return str(DIE_SIZE_LABEL_TEXT, SettingsManager.get_dice_size())
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return die_size_slider.value != SettingsManager.DICE_SIZE_DEFAULT

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed() -> void:
	SettingsManager.set_dice_size(SettingsManager.DICE_SIZE_DEFAULT)
	emit_signal("setting_changed")

