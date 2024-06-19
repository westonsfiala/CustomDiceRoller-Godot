extends CollapsibleSettingBase
class_name EnableColorNegationSetting

@onready var enable_button : Button = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/EnableDisableContainer/EnableButton
@onready var disable_button : Button = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/EnableDisableContainer/DisableButton
@onready var button_container : HBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/EnableDisableContainer

const COLOR_NEGATION_LABEL_TEXT : String = "Color Negation - "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SettingsManager.color_negation_enabled_changed.connect(reconfigure_buttons)
	reconfigure_buttons()
	
# Make sure the buttons are nice and visible.
func reconfigure_buttons() -> void:
	if SettingsManager.get_color_negation_enabled():
		enable_button.button_pressed = true
		disable_button.button_pressed = false
	else:
		enable_button.button_pressed = false
		disable_button.button_pressed = true
	
	show_hide_reset_button()
	set_title()
	
func inner_get_title() -> String:
	var enabled_string : String = "Disabled"
	if SettingsManager.get_color_negation_enabled():
		enabled_string = "Enabled"
	return str(COLOR_NEGATION_LABEL_TEXT, enabled_string)
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return SettingsManager.get_color_negation_enabled() != SettingsManager.COLOR_NEGATION_ENABLED_DEFAULT

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed() -> void:
	SettingsManager.set_color_negation_enabled(SettingsManager.COLOR_NEGATION_ENABLED_DEFAULT)
	emit_signal("setting_changed")

# Set the color negation enabled to true.
func _on_enable_button_pressed() -> void:
	SettingsManager.set_color_negation_enabled(true)
	emit_signal("setting_changed")

# Set the color negation enabled to false.
func _on_disable_button_pressed() -> void:
	SettingsManager.set_color_negation_enabled(false)
	emit_signal("setting_changed")
