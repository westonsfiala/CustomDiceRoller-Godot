extends Control
class_name DiceSizeSetting

@onready var die_size_label : SettingsManagedRichTextLabel = $HBoxContainer/VBoxContainer/DieSizeRichTextLabel
@onready var die_size_slider : HSlider = $HBoxContainer/VBoxContainer/DieSizeSlider
@onready var die_size_visualizer : TextureRect = $HBoxContainer/DieSizeVisualizer
@onready var slider_container : VBoxContainer = $HBoxContainer/VBoxContainer

const DIE_SIZE_LABEL_TEXT : String = "Die Size - "

# Connect to the setting we will be modifying
func _ready():
	SettingsManager.window_size_changed.connect(reconfigure_slider)
	SettingsManager.dice_size_changed.connect(reconfigure_visualizer)
	die_size_slider.set_value_no_signal(SettingsManager.get_dice_size())
	reconfigure_slider()
	reconfigure_visualizer()

# Reconfigures the slider and its maximum value to be half the screen width
func reconfigure_slider():
	var window_size = SettingsManager.get_window_size()
	# Only let stuff be half the window size, minus a bit to make it so 
	# you can have side by side dice in the simple roll view
	die_size_slider.max_value = window_size.x/2 - 10

# Grabs the offical value from the settings manager and sets the size
func reconfigure_visualizer():
	set_visualizer_size(SettingsManager.get_dice_size())
	
# Sets the size of the visualizer to the given value
func set_visualizer_size(new_size: int):
	var vector_size = Vector2.ONE * new_size
	die_size_visualizer.custom_minimum_size = vector_size
	die_size_visualizer.size = vector_size
	
	die_size_label.text = str(DIE_SIZE_LABEL_TEXT, new_size)
	
	custom_minimum_size.y = max(slider_container.size.y, new_size)

# When the slider changes value update the size of the visualizer
func _on_die_size_slider_value_changed(value: float):
	set_visualizer_size(int(value))

# When the drag ends and the value changes, update the settings manager.
func _on_die_size_slider_drag_ended(value_changed):
	if value_changed:
		SettingsManager.set_dice_size(int(die_size_slider.value))
