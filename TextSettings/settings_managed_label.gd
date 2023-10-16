extends Label

func _ready():
	SettingsManager.reconfigure.connect(reconfigure)
	
# Reconfigures the scene according to the settings
func reconfigure():
	label_settings = SettingsManager.get_label_settings()
