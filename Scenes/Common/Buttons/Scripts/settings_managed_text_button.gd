extends LongPressButton
class_name SettingsManagedTextButton

# Called when the node enters the scene tree for the first time.
func _ready():
	SettingsManager.reconfigure.connect(deferred_reconfigure)
	deferred_reconfigure()
	
func deferred_reconfigure():
	call_deferred("reconfigure")

# Reconfigures the scene according to the settings
func reconfigure():
	print("reconfiguring text button")
	
	var button_size = SettingsManager.get_button_size()
	custom_minimum_size.y = button_size
