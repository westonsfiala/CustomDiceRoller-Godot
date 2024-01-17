extends LongPressButton
class_name SettingsManagedTextButton

# Called when the node enters the scene tree for the first time.
func _ready():
	SettingsManager.button_size_changed.connect(reconfigure)
	reconfigure()

# Reconfigures the scene according to the settings
func reconfigure():
	var button_size = SettingsManager.get_button_size()
	custom_minimum_size.y = button_size
