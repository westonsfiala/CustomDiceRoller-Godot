extends CollapsibleSettingBase
class_name EnableAnimationsSetting

@onready var inner_settings_container : VBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/InnerSettingsContainer
@onready var shake_volume_setting : ShakeVolumeSetting = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/InnerSettingsContainer/ShakeVolumeSetting

const ANIMATIONS_LABEL_TEXT : String = "Animations - "

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	# The default is collapsed, so expand if we are enabled.
	var animations_enabled = SettingsManager.get_animations_enabled()
	if animations_enabled:
		start_expanded()
		call_deferred("start_expanded")
	inner_settings_container.minimum_size_changed.connect(setting_size_responder)

# Calls the size responder deferred which is needed when setting size directly
func setting_size_responder():
	call_deferred("deferred_size_responder")

# Set the size of the collapsible section 
func deferred_size_responder():
	#var new_size = inner_settings_container.size.y
	#shake_volume_setting.size.y = shake_volume_setting.custom_minimum_size.y
	#collapsible_section.custom_minimum_size.y = new_size
	#collapsible_section.size.y = new_size
	collapsible_section.custom_minimum_size.y = inner_settings_container.size.y
	enforce_all_content_shown()
	
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


