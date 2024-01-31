extends CollapsibleSettingBase
class_name DiceTintSetting

@onready var color_picker : ColorPicker = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/ColorPicker

const DIE_TINT_LABEL_TEXT : String = "Dice Tint - "

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	SettingsManager.dice_tint_color_changed.connect(reconfigure_sliders)
	reconfigure_sliders()
	
# Grabs the offical value from the settings manager and sets the size
func reconfigure_sliders():
	var new_color: Color = SettingsManager.get_dice_tint_color()
	color_picker.color = new_color
	set_title()
	show_hide_reset_button()
	
func inner_get_title() -> String:
	return str(DIE_TINT_LABEL_TEXT, SettingsManager.get_dice_tint_color().to_html())

# Method for inherited class to get the minimum height of the collapsible section
func inner_get_collapsible_section_minimum_height() -> int:
	return int(color_picker.size.y)
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return SettingsManager.get_dice_tint_color() != SettingsManager.DICE_TINT_COLOR_DEFAULT

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed():
	SettingsManager.set_dice_tint_color(SettingsManager.DICE_TINT_COLOR_DEFAULT)

func _on_color_picker_color_changed(color):
	SettingsManager.set_dice_tint_color(color)
	emit_signal("setting_changed")
