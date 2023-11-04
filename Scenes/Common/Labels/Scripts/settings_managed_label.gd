extends Label
class_name SettingsManagedLabel

@export var is_small_text : bool = false

func _ready():
	SettingsManager.reconfigure.connect(reconfigure)
	call_deferred("reconfigure")
	
# Reconfigures the scene according to the settings
func reconfigure():
	custom_minimum_size.y = SettingsManager.get_text_size()
