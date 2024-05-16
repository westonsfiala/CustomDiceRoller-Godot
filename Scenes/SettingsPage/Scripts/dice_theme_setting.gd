extends CollapsibleSettingBase
class_name DiceThemeSetting

@onready var themes_container : VBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/ThemesContainer

const DIE_THEME_LABEL_TEXT : String = "Theme - "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SettingsManager.dice_theme_changed.connect(show_hide_reset_button)
	SettingsManager.dice_theme_changed.connect(set_title)
	
func inner_get_title() -> String:
	return str(DIE_THEME_LABEL_TEXT, DieImageManager.get_theme_name_from_enum(SettingsManager.get_dice_theme()))
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return SettingsManager.get_dice_theme() != SettingsManager.DICE_THEME_DEFAULT

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed() -> void:
	SettingsManager.set_dice_theme(SettingsManager.DICE_THEME_DEFAULT)
	show_hide_reset_button()
