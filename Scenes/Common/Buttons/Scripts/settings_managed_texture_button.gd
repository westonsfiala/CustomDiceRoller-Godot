extends LongPressButton
class_name SettingsManagedTextureButton

@export var texture_2d : Texture2D = preload("res://Icons/circle-cancel.svg")

@onready var margin_container : MarginContainer = $MarginContainer
@onready var texture_rect : TextureRect = $MarginContainer/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_rect.texture = texture_2d
	SettingsManager.button_size_changed.connect(reconfigure)
	reconfigure()
	
# Reconfigures the scene according to the settings
func reconfigure() -> void:
	var button_size : int = SettingsManager.get_button_size()
	custom_minimum_size = Vector2.ONE * button_size
	pivot_offset = custom_minimum_size/2
	
func set_new_button_texture(new_texture: Texture2D) -> void:
	texture_2d = new_texture
	texture_rect.texture = new_texture
