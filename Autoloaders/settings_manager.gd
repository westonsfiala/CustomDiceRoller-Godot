extends Node

var default_die : MinMaxDie = MinMaxDie.new("TEMP", 1, 1, preload("res://DicePNGs/white/unknown-die.png"))
var fate : MinMaxDie = MinMaxDie.new("fate", -1, 1, preload("res://DicePNGs/white/fate.png"))
var d2 : MinMaxDie = MinMaxDie.new("d2", 1, 2, preload("res://DicePNGs/white/d2.png"))
var d3 : MinMaxDie = MinMaxDie.new("d3", 1, 3, preload("res://DicePNGs/white/d3.png"))
var d4 : MinMaxDie = MinMaxDie.new("d4", 1, 4, preload("res://DicePNGs/white/d4.png"))
var d6 : MinMaxDie = MinMaxDie.new("d6", 1, 6, preload("res://DicePNGs/white/d6.png"))
var d8 : MinMaxDie = MinMaxDie.new("d8", 1, 8, preload("res://DicePNGs/white/d8.png"))
var d10 : MinMaxDie = MinMaxDie.new("d10", 1, 10, preload("res://DicePNGs/white/d10.png"))
var d12 : MinMaxDie = MinMaxDie.new("d12", 1, 12, preload("res://DicePNGs/white/d12.png"))
var d20 : MinMaxDie = MinMaxDie.new("d20", 1, 20, preload("res://DicePNGs/white/d20.png"))
var d100 : MinMaxDie = MinMaxDie.new("d100", 1, 100, preload("res://DicePNGs/white/d100.png"))
var default_dice_array : Array[AbstractDie] = [fate, d2, d3, d4, d6, d8, d10, d12, d20, d100]

var dice_size : int = 150

var app_bar_size : int = 50
var margin_padding : int = 10

enum SCENE {HISTORY, SIMPLE_ROLL, NUM_SCENES}

var default_label_settings : LabelSettings = preload("res://Resources/Styles/default_normal_label.tres")
var default_small_label_settings : LabelSettings = preload("res://Resources/Styles/default_small_label.tres")

signal reconfigure()
signal scene_scroll_value_changed(value: int)
signal navigate_to_scene(scene: SCENE)

func trigger_reconfigure():
	print("triggering reconfigure")
	emit_signal("reconfigure")

func get_default_die() -> AbstractDie:
	return default_die

func get_dice() -> Array[AbstractDie]:
	return default_dice_array
	
func get_default_app_page() -> int:
	return SCENE.SIMPLE_ROLL

func get_scene_name(scene_enum: SCENE) -> String:
	match scene_enum:
		SCENE.HISTORY: 
			return "History"
		SCENE.SIMPLE_ROLL: 
			return "Simple Roll"
		_:
			return "TEMP"
	
func set_scene_scroll_value(value: int):
	emit_signal("scene_scroll_value_changed", value)
	
func set_scrolled_scene(scene: SCENE):
	emit_signal("navigate_to_scene", scene)
	
func get_window_size() -> Vector2:
	return DisplayServer.window_get_size()
	
func get_num_scrollable_scenes() -> int:
	return SCENE.NUM_SCENES
	
func get_dice_size() -> int:
	return dice_size
	
func get_app_bar_size() -> int:
	return app_bar_size
	
func get_margin_padding() -> int:
	return margin_padding
	
func get_label_settings() -> LabelSettings:
	return default_label_settings
	
func get_small_label_settings() -> LabelSettings:
	return default_small_label_settings

# Removes all the children nodes of a given node and frees them
func remove_and_free_children(node: Node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
