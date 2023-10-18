extends Button

@export var scene_enum : SettingsManager.SCENE

@onready var scene_name_label : Label = $SceneNameLabel

signal scene_navigation_pressed(scene: SettingsManager.SCENE)

# Called when the node enters the scene tree for the first time.
func _ready():
	scene_name_label.text = SettingsManager.get_scene_name(scene_enum)

func _on_pressed():
	print("Navigating to ", scene_name_label.text)
	emit_signal("scene_navigation_pressed", scene_enum)
