extends LongPressButton
class_name SettingsManagedTextButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SettingsManager.button_size_changed.connect(reconfigure)
	reconfigure()

# Reconfigures the scene according to the settings
func reconfigure() -> void:
	var button_size : int = SettingsManager.get_button_size()
	custom_minimum_size.y = button_size
