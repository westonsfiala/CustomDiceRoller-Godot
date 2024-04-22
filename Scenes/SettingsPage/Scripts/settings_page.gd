extends Control
class_name SettingsPage

# Connect to the settings manager
func _ready() -> void:
	SettingsManager.window_size_changed.connect(reconfigure)
	reconfigure()

# Remove all of our currently set diced and place new ones
func reconfigure() -> void:
	custom_minimum_size.x = SettingsManager.get_window_size().x
