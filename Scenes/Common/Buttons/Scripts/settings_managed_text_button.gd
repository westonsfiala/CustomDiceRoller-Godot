extends LongPressButton
class_name SettingsManagedTextButton

@export var button_text : String = "TEMP"
@export var is_small_text : bool = false

@onready var label : SettingsManagedLabel = $SettingsManagedLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = button_text
	label.is_small_text = is_small_text
	SettingsManager.reconfigure.connect(reconfigure)
	call_deferred("reconfigure")
	
# Reconfigures the scene according to the settings
func reconfigure():
	print("reconfiguring text button")
	
	var button_size = SettingsManager.get_button_size()
	custom_minimum_size.y = button_size
