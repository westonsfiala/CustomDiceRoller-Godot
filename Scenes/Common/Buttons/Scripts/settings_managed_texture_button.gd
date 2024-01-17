extends LongPressButton
class_name SettingsManagedTextureButton

@export var texture_2d : Texture2D = preload("res://Icons/circle-cancel.svg")

@onready var margin_container : MarginContainer = $MarginContainer
@onready var texture_rect : TextureRect = $MarginContainer/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_rect.texture = texture_2d
	SettingsManager.window_size_changed.connect(reconfigure)
	call_deferred("reconfigure")
	
# Reconfigures the scene according to the settings
func reconfigure():
	var button_size = SettingsManager.get_button_size()
	custom_minimum_size = Vector2.ONE * button_size
