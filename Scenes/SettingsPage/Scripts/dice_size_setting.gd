extends Control
class_name DiceSizeSetting

@onready var settings_arrow : SettingsManagedTextureButton = $SliderContainer/TextContainer/SettingsArrow
@onready var die_size_label : SettingsManagedRichTextLabel = $SliderContainer/TextContainer/DieSizeRichTextLabel
@onready var dice_size_collapsible : Control = $SliderContainer/DiceSizeCollapsible
@onready var die_size_slider : HSlider = $SliderContainer/DiceSizeCollapsible/DieSizeSlider
@onready var reset_button : Button = $SliderContainer/TextContainer/ResetButton
@onready var slider_container : VBoxContainer = $SliderContainer
@onready var text_container : HBoxContainer = $SliderContainer/TextContainer

const DIE_SIZE_LABEL_TEXT : String = "Die Size - "

var tween : Tween

# Connect to the setting we will be modifying
func _ready():
	SettingsManager.window_size_changed.connect(reconfigure_slider)
	SettingsManager.dice_size_changed.connect(reconfigure_slider)
	SettingsManager.button_size_changed.connect(reconfigure_slider)
	start_collapsed()
	reconfigure_slider()
	
# Start with the setting collapsed
func start_collapsed():
	# You have to do this weird tween stuff because setting the rotation directly
	# doesn't work for some unknown reason.
	tween = get_tree().create_tween()
	tween.tween_property(settings_arrow, "rotation_degrees", -90, 0).from(0)
	dice_size_collapsible.scale = Vector2(1,0)
	dice_size_collapsible.custom_minimum_size.y = 0
	dice_size_collapsible.size.y = 0
	dice_size_collapsible.visible = false

# Toggle showing/hiding the dice settings.
func expand_collapse_inner_settings():
	var button_size = SettingsManager.get_button_size()
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	if dice_size_collapsible.visible:
		tween.tween_property(settings_arrow, "rotation_degrees", -90, SettingsManager.LONG_PRESS_DELAY).from(0)
		tween.tween_property(die_size_slider, "scale", Vector2(1, 0), SettingsManager.LONG_PRESS_DELAY).from(Vector2.ONE)
		tween.tween_method(set_slider_content_height, button_size, 0, SettingsManager.LONG_PRESS_DELAY)
		tween.chain().tween_callback(hide_slider_callback)
	else:
		dice_size_collapsible.visible = true
		tween.tween_property(settings_arrow, "rotation_degrees", 0, SettingsManager.LONG_PRESS_DELAY).from(-90)
		tween.tween_property(die_size_slider, "scale", Vector2.ONE, SettingsManager.LONG_PRESS_DELAY).from(Vector2(1, 0))
		tween.tween_method(set_slider_content_height, 0, button_size, SettingsManager.LONG_PRESS_DELAY)

func hide_slider_callback():
	dice_size_collapsible.visible = false
	enforce_all_content_shown()

# Method for setting the height of the slider when its expanding / collapsing
func set_slider_content_height(current_content_height: int):
	dice_size_collapsible.custom_minimum_size.y = current_content_height
	dice_size_collapsible.size.y = current_content_height
	enforce_all_content_shown()

# Method for having the proper size of the setting at all times.
func enforce_all_content_shown():
	custom_minimum_size.y = text_container.custom_minimum_size.y + dice_size_collapsible.custom_minimum_size.y
	
# Reconfigures the slider and its maximum value to be half the screen width
func reconfigure_slider():
	var window_size = SettingsManager.get_window_size()
	var button_size = SettingsManager.get_button_size()
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
	
	text_container.custom_minimum_size.y = button_size
	enforce_all_content_shown()
	hide_reset_button()
	
func hide_reset_button():
	if SettingsManager.get_dice_size() == SettingsManager.DICE_SIZE_DEFAULT:
		reset_button.visible = false
	else:
		reset_button.visible = true

# When the slider changes value update the size of the visualizer
func _on_die_size_slider_value_changed(value: float):
	SettingsManager.set_dice_size(int(die_size_slider.value))

# Reset the dice size to the default
func _on_reset_button_pressed():
	SettingsManager.set_dice_size(SettingsManager.DICE_SIZE_DEFAULT)
