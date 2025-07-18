extends CollapsibleSettingBase
class_name MinMaxHighlightSetting

@onready var enable_button : Button = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/EnableDisableContainer/EnableButton
@onready var disable_button : Button = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/EnableDisableContainer/DisableButton
@onready var button_container : HBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/EnableDisableContainer

const MIN_MAX_HIGHLIGHT_LABEL_TEXT : String = "Min Max Highlight - "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SettingsManager.min_max_highlight_enabled_changed.connect(reconfigure_buttons)
	reconfigure_buttons()
	
# Make sure the buttons are nice and visible.
func reconfigure_buttons() -> void:
	if SettingsManager.get_min_max_highlight_enabled():
		enable_button.button_pressed = true
		disable_button.button_pressed = false
	else:
		enable_button.button_pressed = false
		disable_button.button_pressed = true
	
	show_hide_reset_button()
	set_title()
	
# Method for inherited class to get the title to display
func inner_get_title() -> String:
	var min_max_highlight_enabled_string : String = "Disabled"
	if SettingsManager.get_min_max_highlight_enabled():
		min_max_highlight_enabled_string = "Enabled"
	return str(MIN_MAX_HIGHLIGHT_LABEL_TEXT, min_max_highlight_enabled_string)
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return SettingsManager.get_min_max_highlight_enabled() != SettingsManager.MIN_MAX_HIGHLIGHT_ENABLED_DEFAULT

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed() -> void:
	SettingsManager.set_min_max_highlight_enabled(SettingsManager.MIN_MAX_HIGHLIGHT_ENABLED_DEFAULT)
	emit_signal("setting_changed")

# Set the min max highlight enabled to true.
func _on_enable_button_pressed() -> void:
	SettingsManager.set_min_max_highlight_enabled(true)
	emit_signal("setting_changed")

# Set the min max highlight enabled to false.
func _on_disable_button_pressed() -> void:
	SettingsManager.set_min_max_highlight_enabled(false)
	emit_signal("setting_changed")
