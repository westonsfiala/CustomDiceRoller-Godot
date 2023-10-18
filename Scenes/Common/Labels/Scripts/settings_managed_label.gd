extends Label

@export var is_small_text : bool = false

func _ready():
	SettingsManager.reconfigure.connect(reconfigure)
	call_deferred("reconfigure")
	
# Reconfigures the scene according to the settings
func reconfigure():
	if is_small_text:
		label_settings = SettingsManager.get_small_label_settings()
	else:
		label_settings = SettingsManager.get_label_settings()
