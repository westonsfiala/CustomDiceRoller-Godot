extends Label
class_name SettingsManagedLabel

func _ready() -> void:
	SettingsManager.window_size_changed.connect(reconfigure)
	call_deferred("reconfigure")
	
# Reconfigures the scene according to the settings
func reconfigure() -> void:
	var font_size : int = get_theme_font_size("font_size", theme_type_variation)
	custom_minimum_size.y = get_theme_default_font().get_height(font_size)
