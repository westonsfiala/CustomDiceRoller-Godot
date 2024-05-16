extends CollapsibleSettingBase
class_name IceCreamDiceThemesSetting

@onready var theme_container : VBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/ThemeContainer

const ICE_CREAM_DIE_THEME_LABEL_TEXT : String = "Ice Cream"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	
func inner_get_title() -> String:
	return ICE_CREAM_DIE_THEME_LABEL_TEXT
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return false

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed() -> void:
	pass
