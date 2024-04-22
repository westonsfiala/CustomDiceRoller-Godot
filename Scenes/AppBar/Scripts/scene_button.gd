extends SettingsManagedTextButton 
class_name SceneButton

@export var scene_enum : SettingsManager.SCENE

signal scene_navigation_pressed(scene: SettingsManager.SCENE)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	text = SettingsManager.get_scene_name(scene_enum)

func _on_pressed() -> void:
	print("Navigating to ", text)
	emit_signal("scene_navigation_pressed", scene_enum)
