extends Label

@export var is_small_text : bool = false

func _ready():
	SettingsManager.reconfigure.connect(reconfigure)
	call_deferred("reconfigure")
	
# Reconfigures the scene according to the settings
func reconfigure():
	print("reconfiguring label")
	if is_small_text:
		label_settings = SettingsManager.get_small_label_settings()
		custom_minimum_size.y = SettingsManager.get_text_size()
	else:
		label_settings = SettingsManager.get_label_settings()
		custom_minimum_size.y = SettingsManager.get_text_size_small()
