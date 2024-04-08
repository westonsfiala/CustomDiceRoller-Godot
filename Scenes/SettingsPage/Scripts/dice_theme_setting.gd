extends CollapsibleSettingBase
class_name DiceThemeSetting

@onready var themes_container : VBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/ThemesContainer

const DIE_THEME_LABEL_TEXT : String = "Theme - "

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	SettingsManager.dice_theme_changed.connect(show_hide_reset_button)
	SettingsManager.dice_theme_changed.connect(set_title)
	themes_container.minimum_size_changed.connect(setting_size_responder)
	
func setting_size_responder():
	call_deferred("deferred_size_responder")
	
func deferred_size_responder():
	collapsible_section.custom_minimum_size.y = themes_container.size.y
	enforce_all_content_shown()
	
func inner_get_title() -> String:
	return str(DIE_THEME_LABEL_TEXT, DieImageManager.get_theme_name_from_enum(SettingsManager.get_dice_theme()))

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
