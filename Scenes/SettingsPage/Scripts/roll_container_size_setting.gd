extends CollapsibleSettingBase
class_name RollContainerSizeSetting

@onready var fullscreen_button : Button = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/ButtonContainer/FullscreenButton
@onready var dialog_button : Button = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/ButtonContainer/DialogButton
@onready var minimal_button : Button = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/ButtonContainer/MinimalButton
@onready var button_container : HBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/ButtonContainer

const ROLL_CONTAINER_SIZE_LABEL_TEXT : String = "Roll Container Size - "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SettingsManager.roll_container_size_changed.connect(reconfigure_buttons)
	reconfigure_buttons()
	
# Make sure the buttons are nice and visible.
func reconfigure_buttons() -> void:
	match SettingsManager.get_roll_container_size():
		SettingsManager.ROLL_CONTAINER_SIZE.FULLSCREEN:
			fullscreen_button.button_pressed = true
			dialog_button.button_pressed = false
			minimal_button.button_pressed = false
		SettingsManager.ROLL_CONTAINER_SIZE.DIALOG:
			fullscreen_button.button_pressed = false
			dialog_button.button_pressed = true
			minimal_button.button_pressed = false
		SettingsManager.ROLL_CONTAINER_SIZE.MINIMAL:
			fullscreen_button.button_pressed = false
			dialog_button.button_pressed = false
			minimal_button.button_pressed = true
	
	show_hide_reset_button()
	set_title()
	
func inner_get_title() -> String:
	var roll_container_size_string : String = "Fullscreen"
		
	match SettingsManager.get_roll_container_size():
		SettingsManager.ROLL_CONTAINER_SIZE.FULLSCREEN:
			roll_container_size_string = "Fullscreen"
		SettingsManager.ROLL_CONTAINER_SIZE.DIALOG:
			roll_container_size_string = "Dialog"
		SettingsManager.ROLL_CONTAINER_SIZE.MINIMAL:
			roll_container_size_string = "Minimal"
	return str(ROLL_CONTAINER_SIZE_LABEL_TEXT, roll_container_size_string)

# Method for inherited class to get the minimum height of the collapsible section
func inner_get_collapsible_section_minimum_height() -> int:
	return int(button_container.size.y)
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return SettingsManager.get_roll_container_size() != SettingsManager.ROLL_CONTAINER_SIZE_DEFAULT

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed() -> void:
	SettingsManager.set_roll_container_size(SettingsManager.ROLL_CONTAINER_SIZE_DEFAULT)
	emit_signal("setting_changed")

# Set to fullscreen.
func _on_fullscreen_button_pressed() -> void:
	SettingsManager.set_roll_container_size(SettingsManager.ROLL_CONTAINER_SIZE.FULLSCREEN)
	emit_signal("setting_changed")

# Set to dialog
func _on_dialog_button_pressed() -> void:
	SettingsManager.set_roll_container_size(SettingsManager.ROLL_CONTAINER_SIZE.DIALOG)
	emit_signal("setting_changed")

# Set to minimal
func _on_minimal_button_pressed() -> void:
	SettingsManager.set_roll_container_size(SettingsManager.ROLL_CONTAINER_SIZE.MINIMAL)
	emit_signal("setting_changed")
