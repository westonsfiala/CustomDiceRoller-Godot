extends CollapsibleSettingBase
class_name DieResultSoundsSetting

@onready var enable_button : Button = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/DieResultContainer/EnableDisableContainer/EnableButton
@onready var disable_button : Button = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/DieResultContainer/EnableDisableContainer/DisableButton
@onready var die_result_container : VBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/DieResultContainer

const DIE_RESULT_SOUNDS_LABEL_TEXT : String = "Die Result Sounds - "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SettingsManager.die_result_sounds_enabled_changed.connect(reconfigure_buttons)
	reconfigure_buttons()
	
# Make sure the buttons are nice and visible.
func reconfigure_buttons() -> void:
	if SettingsManager.get_die_result_sounds_enabled():
		enable_button.button_pressed = true
		disable_button.button_pressed = false
	else:
		enable_button.button_pressed = false
		disable_button.button_pressed = true
	
	show_hide_reset_button()
	set_title()
	
# Method for inherited class to get the title to display
func inner_get_title() -> String:
	var die_result_sounds_enabled_string : String = "Disabled"
	if SettingsManager.get_die_result_sounds_enabled():
		die_result_sounds_enabled_string = "Enabled"
	return str(DIE_RESULT_SOUNDS_LABEL_TEXT, die_result_sounds_enabled_string)

# Method for inherited class to get the minimum height of the collapsible section
func inner_get_collapsible_section_minimum_height() -> int:
	return int(die_result_container.size.y)
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return SettingsManager.get_die_result_sounds_enabled() != SettingsManager.DIE_RESULT_SOUNDS_ENABLED_DEFAULT

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed() -> void:
	SettingsManager.set_die_result_sounds_enabled(SettingsManager.DIE_RESULT_SOUNDS_ENABLED_DEFAULT)
	emit_signal("setting_changed")

# Set the die result sounds enabled to true.
func _on_enable_button_pressed() -> void:
	SettingsManager.set_die_result_sounds_enabled(true)
	emit_signal("setting_changed")

# Set the die result sounds enabled to false.
func _on_disable_button_pressed() -> void:
	SettingsManager.set_die_result_sounds_enabled(false)
	emit_signal("setting_changed")
