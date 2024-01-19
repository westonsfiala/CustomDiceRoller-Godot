extends Control
class_name DiceSizeSetting

@onready var die_size_label : SettingsManagedRichTextLabel = $SliderContainer/HBoxContainer/DieSizeRichTextLabel
@onready var die_size_slider : HSlider = $SliderContainer/DieSizeSlider
@onready var slider_container : VBoxContainer = $SliderContainer

const DIE_SIZE_LABEL_TEXT : String = "Die Size - "

# Connect to the setting we will be modifying
func _ready():
	SettingsManager.window_size_changed.connect(reconfigure_slider)
	SettingsManager.dice_size_changed.connect(reconfigure_slider)
	reconfigure_slider()

# Reconfigures the slider and its maximum value to be half the screen width
func reconfigure_slider():
	var window_size = SettingsManager.get_window_size()
	# Only let dice size be half the window size, minus a bit to make it so 
	# you can have side by side dice in the simple roll view
	die_size_slider.max_value = min(window_size.x, window_size.y)/2 - 10
	
	# Set the text and the current slider value.
	# If the max is smaller than our current value, lower our current value.
	var new_size = SettingsManager.get_dice_size()
	if new_size > die_size_slider.max_value:
		new_size = die_size_slider.max_value
		die_size_slider.value = new_size
	die_size_slider.set_value_no_signal(new_size)
	die_size_label.set_text_and_resize_y(str(DIE_SIZE_LABEL_TEXT, new_size))
	
	custom_minimum_size.y = slider_container.size.y

# When the slider changes value update the size of the visualizer
func _on_die_size_slider_value_changed(value: float):
	SettingsManager.set_dice_size(int(die_size_slider.value))

# Reset the dice size to the default
func _on_settings_managed_texture_button_pressed():
	SettingsManager.set_dice_size(SettingsManager.DICE_SIZE_DEFAULT)
