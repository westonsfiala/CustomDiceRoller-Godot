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

var default_label_settings : LabelSettings = preload("res://TextSettings/default_label.tres")

var minimum_die_size : int = 100
var maximum_die_size : int = 500

signal reconfigure()

func trigger_reconfigure():
	emit_signal("reconfigure")

func get_default_die() -> AbstractDie:
	return default_die

func get_default_dice() -> Array[AbstractDie]:
	return default_dice_array
	
func get_window_size() -> Vector2:
	return DisplayServer.window_get_size()
	
func get_dice_size() -> int:
	return dice_size
	
func get_minimum_die_size() -> int:
	return minimum_die_size
	
func get_maximum_die_size() -> int:
	return maximum_die_size
	
func get_label_settings() -> LabelSettings:
	return default_label_settings
