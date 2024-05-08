extends CollapsibleSettingBase
class_name ShowExpectedResultSetting

@onready var enable_button : Button = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/EnableDisableContainer/EnableButton
@onready var disable_button : Button = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/EnableDisableContainer/DisableButton
@onready var button_container : HBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/EnableDisableContainer

const SHOW_EXPECTED_RESULT_LABEL_TEXT : String = "Show Expected Result - "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SettingsManager.show_expected_result_enabled_changed.connect(reconfigure_buttons)
	reconfigure_buttons()
	
# Make sure the buttons are nice and visible.
func reconfigure_buttons() -> void:
	if SettingsManager.get_show_expected_result_enabled():
		enable_button.button_pressed = true
		disable_button.button_pressed = false
	else:
		enable_button.button_pressed = false
		disable_button.button_pressed = true
	
	show_hide_reset_button()
	set_title()
	
# Method for inherited class to get the title to display
func inner_get_title() -> String:
	var show_expected_result_enabled_string : String = "Disabled"
	if SettingsManager.get_show_expected_result_enabled():
		show_expected_result_enabled_string = "Enabled"
	return str(SHOW_EXPECTED_RESULT_LABEL_TEXT, show_expected_result_enabled_string)

# Method for inherited class to get the minimum height of the collapsible section
func inner_get_collapsible_section_minimum_height() -> int:
	return int(button_container.size.y)
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return SettingsManager.get_show_expected_result_enabled() != SettingsManager.SHOW_EXPECTED_RESULT_ENABLED_DEFAULT

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed() -> void:
	SettingsManager.set_show_expected_result_enabled(SettingsManager.SHOW_EXPECTED_RESULT_ENABLED_DEFAULT)
	emit_signal("setting_changed")

# Set the show expected result enabled to true.
func _on_enable_button_pressed() -> void:
	SettingsManager.set_show_expected_result_enabled(true)
	emit_signal("setting_changed")

# Set the show expected result enabled to false.
func _on_disable_button_pressed() -> void:
	SettingsManager.set_show_expected_result_enabled(false)
	emit_signal("setting_changed")
