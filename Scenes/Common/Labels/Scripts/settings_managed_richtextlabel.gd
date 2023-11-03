extends RichTextLabel
class_name SettingsManagedLabel

@onready var label : RichTextLabel = $"."

func _ready():
	SettingsManager.reconfigure.connect(reconfigure)
	call_deferred("reconfigure")
	
# Reconfigures the scene according to the settings
func reconfigure():
	print("reconfiguring richtextlabel")
	custom_minimum_size.y = SettingsManager.get_text_size()

func set_bbcode_text(formatted_text: String):
	label.parse_bbcode("[center]" + formatted_text + "[/center]")
