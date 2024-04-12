extends CollapsibleSettingBase
class_name TopLevelRollerSettings

@onready var settings_container : VBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/SettingsContainer
@onready var enable_animations_setting : EnableAnimationsSetting = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/SettingsContainer/EnableAnimationsSetting
@onready var shake_volume_setting : ShakeVolumeSetting = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/SettingsContainer/ShakeVolumeSetting

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	enable_animations_setting.setting_changed.connect(show_hide_reset_button)
	enable_animations_setting.reset_pressed.connect(show_hide_reset_button)
	shake_volume_setting.setting_changed.connect(show_hide_reset_button)
	shake_volume_setting.reset_pressed.connect(show_hide_reset_button)
	settings_container.minimum_size_changed.connect(size_responder)

# Calls the size responder deferred which is needed when setting size directly
func size_responder():
	call_deferred("deferred_size_responder")

# Set the size of the collapsible section 
func deferred_size_responder():
	var new_size = settings_container.size.y
	collapsible_section.custom_minimum_size.y = new_size
	enforce_all_content_shown()
	
# Gets the title for our top level setting
func inner_get_title() -> String:
	return "Roller"

# Method for inherited class to get the minimum height of the collapsible section
func inner_get_collapsible_section_minimum_height() -> int:
	var inner_size = int(settings_container.size.y)
	return inner_size
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	var should_show = false
	should_show = should_show or enable_animations_setting.inner_should_show_reset_button()
	should_show = should_show or shake_volume_setting.inner_should_show_reset_button()
	return should_show

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed():
	enable_animations_setting.inner_reset_button_pressed()
	shake_volume_setting.inner_reset_button_pressed()
	show_hide_reset_button()
