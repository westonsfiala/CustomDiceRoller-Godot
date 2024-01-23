extends Control
class_name DiceTintSetting

@onready var die_tint_label : SettingsManagedRichTextLabel = $SliderContainer/TextContainer/DieTintRichTextLabel
@onready var die_color_picker : ColorPicker = $SliderContainer/ColorPicker
@onready var reset_button : Button = $SliderContainer/TextContainer/ResetButton
@onready var slider_container : VBoxContainer = $SliderContainer
@onready var text_container : HBoxContainer = $SliderContainer/TextContainer

const DIE_TINT_LABEL_TEXT : String = "Die Tint - "

# Connect to the setting we will be modifying
func _ready():
	SettingsManager.dice_tint_color_changed.connect(reconfigure_sliders)
	SettingsManager.button_size_changed.connect(reconfigure_sliders)
	reconfigure_sliders()

# Grabs the offical value from the settings manager and sets the size
func reconfigure_sliders():
	text_container.custom_minimum_size.y = SettingsManager.get_button_size()
	var new_color: Color = SettingsManager.get_dice_tint_color()
	die_color_picker.color = new_color
	die_tint_label.set_text_and_resize_y(str(DIE_TINT_LABEL_TEXT, new_color.to_html()))
	custom_minimum_size.y = slider_container.size.y
	hide_reset_button()
	
func hide_reset_button():
	if SettingsManager.get_dice_tint_color() == SettingsManager.DICE_TINT_COLOR_DEFAULT:
		reset_button.visible = false
	else:
		reset_button.visible = true

# Sends the new color up to the settings manager.
func _on_color_picker_color_changed(color):
	SettingsManager.set_dice_tint_color(color)

# Reset the dice tint color to default
func _on_reset_button_pressed():
	SettingsManager.set_dice_tint_color(SettingsManager.DICE_TINT_COLOR_DEFAULT)
