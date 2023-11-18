extends Node

var dice_size : int = 150
var button_size : int = 50
var text_size : int = 50
var text_size_small : int = 35
var margin_padding : int = 5

const LONG_PRESS_DELAY : float = 0.5

enum SCENE {HISTORY, SIMPLE_ROLL, NUM_SCENES}

var default_label_settings : LabelSettings = preload("res://Resources/Styles/normal_label.tres")

signal reconfigure()

func trigger_reconfigure():
	print("triggering reconfigure")
	emit_signal("reconfigure")
	
func get_default_app_scene() -> int:
	return SCENE.SIMPLE_ROLL

func get_scene_name(scene_enum: SCENE) -> String:
	match scene_enum:
		SCENE.HISTORY: 
			return "History"
		SCENE.SIMPLE_ROLL: 
			return "Simple Roll"
		_:
			return "TEMP"
	
signal scene_scroll_value_changed(value: int)

func set_scene_scroll_value(value: int):
	emit_signal("scene_scroll_value_changed", value)
	
signal navigate_to_scene(scene: SCENE)

func set_scrolled_scene(scene: SCENE):
	emit_signal("navigate_to_scene", scene)
	
func get_window_size() -> Vector2:
	return DisplayServer.window_get_size()
	
func get_num_scrollable_scenes() -> int:
	return SCENE.NUM_SCENES
	
func get_dice_size() -> int:
	return dice_size
	
func get_button_size() -> int:
	return button_size
	
func get_text_size() -> int:
	return text_size
	
func get_text_size_small() -> int:
	return text_size_small
	
func get_margin_padding() -> int:
	return margin_padding

# Removes all the children nodes of a given node and frees them
func remove_and_free_children(node: Node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
