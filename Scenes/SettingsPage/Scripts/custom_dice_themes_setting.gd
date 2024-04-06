extends CollapsibleSettingBase
class_name CustomDiceThemesSetting

@onready var theme_container : VBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/ThemeContainer
@onready var custom_theme_list_item : CustomThemeListItem = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/ThemeContainer/CustomThemeListItem

const CUSTOM_DIE_THEME_LABEL_TEXT : String = "Custom"

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	DieImageManager.custom_gradient_changed.connect(custom_gradient_modified)
	
func inner_get_title() -> String:
	return CUSTOM_DIE_THEME_LABEL_TEXT

# Method for inherited class to get the minimum height of the collapsible section
func inner_get_collapsible_section_minimum_height() -> int:
	return int(theme_container.size.y)
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return false

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed():
	pass

# Need to do some adjustments when you add or remove colors.
func custom_gradient_modified():
	# The first time that the container is constructed it enters here, but don't want to act on it.
	if theme_container:
		call_deferred("correct_position")
	
# Need to do this in the deferred calling or it doesn't take.
func correct_position():
	theme_container.size.y = 0
	set_collapsible_min_height(inner_get_collapsible_section_minimum_height())
	theme_container.set_position(Vector2.ZERO)
