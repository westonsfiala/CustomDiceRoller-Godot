extends Label
class_name SettingsManagedLabel

func _ready():
	SettingsManager.reconfigure.connect(reconfigure)
	call_deferred("reconfigure")
	
# Reconfigures the scene according to the settings
func reconfigure():
	custom_minimum_size.y = SettingsManager.get_text_size()
