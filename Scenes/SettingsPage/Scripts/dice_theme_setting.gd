extends CollapsibleSettingBase
class_name DiceThemeSetting

@onready var themes_container : VBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/ThemesContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	themes_container.minimum_size_changed.connect(setting_size_responder)
	
func setting_size_responder():
	collapsible_section.custom_minimum_size.y = themes_container.size.y
	enforce_all_content_shown()

# Method for inherited class to get the minimum height of the collapsible section
func inner_get_collapsible_section_minimum_height() -> int:
	return int(themes_container.size.y)
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return SettingsManager.get_dice_theme() != SettingsManager.DICE_THEME_DEFAULT

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed():
	SettingsManager.set_dice_theme(SettingsManager.DICE_THEME_DEFAULT)
	show_hide_reset_button()
