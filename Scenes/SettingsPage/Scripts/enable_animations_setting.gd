extends CollapsibleSettingBase
class_name EnableAnimationsSetting

@onready var inner_settings_container : VBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/InnerSettingsContainer

const ANIMATIONS_LABEL_TEXT : String = "Animations - "

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	# The default is collapsed, so expand if we are enabled.
	var animations_enabled = SettingsManager.get_animations_enabled()
	if animations_enabled:
		#helper_expand_collapse_inner_settings(animations_enabled)
		#call_deferred("helper_expand_collapse_inner_settings", animations_enabled)
		start_expanded()
		call_deferred("start_expanded")
	
# Overwrite this method to enable/disable as we press it.
func expand_collapse_inner_settings():
	var animations_enabled = SettingsManager.get_animations_enabled()
	SettingsManager.set_animations_enabled(not animations_enabled)
	set_title()
	show_hide_reset_button()
	emit_signal("setting_changed")
	super()
	
func inner_get_title() -> String:
	var animations_enabled_string = "Disabled"
	if SettingsManager.get_animations_enabled():
		animations_enabled_string = "Enabled"
	return str(ANIMATIONS_LABEL_TEXT, animations_enabled_string)

# Method for inherited class to get the minimum height of the collapsible section
func inner_get_collapsible_section_minimum_height() -> int:
	return int(inner_settings_container.size.y)
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return SettingsManager.get_animations_enabled() != SettingsManager.ANIMATIONS_ENABLED_DEFAULT

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed():
	if SettingsManager.get_animations_enabled() != SettingsManager.ANIMATIONS_ENABLED_DEFAULT:
		if visible:
			helper_expand_collapse_inner_settings(SettingsManager.ANIMATIONS_ENABLED_DEFAULT)
		else:
			start_expanded()
		SettingsManager.set_animations_enabled(SettingsManager.ANIMATIONS_ENABLED_DEFAULT)
		set_title()
		show_hide_reset_button()
		emit_signal("setting_changed")


