extends Node

const DIE_UNKNOWN : int = -1
const DIE_FATE : int = 0
const DIE_2 : int = 2
const DIE_3 : int = 3
const DIE_4 : int = 4
const DIE_6 : int = 6
const DIE_8 : int = 8
const DIE_10 : int = 10
const DIE_12 : int = 12
const DIE_20 : int = 20
const DIE_100 : int = 100

func get_die_image(imageID : int) -> String:
	# TODO: Get the theme stuff going.
	var selectedTheme = 'white'
	
	var die_name = 'unknown-die'
	
	match(imageID):
		DIE_FATE: die_name = "fate"
		DIE_2: die_name = "d2"
		DIE_3: die_name = "d3"
		DIE_4: die_name = "d4"
		DIE_6: die_name = "d6"
		DIE_8: die_name = "d8"
		DIE_10: die_name = "d10"
		DIE_12: die_name = "d12"
		DIE_20: die_name = "d20"
		DIE_100: die_name = "d100"
	
	return str("res://DicePNGs/", selectedTheme,"/", die_name,".png")

func get_die_image_white(image_id: int) -> String:
	var die_name = 'unknown-die'
	
	match(image_id):
		DIE_FATE: die_name = "fate"
		DIE_2: die_name = "d2"
		DIE_3: die_name = "d3"
		DIE_4: die_name = "d4"
		DIE_6: die_name = "d6"
		DIE_8: die_name = "d8"
		DIE_10: die_name = "d10"
		DIE_12: die_name = "d12"
		DIE_20: die_name = "d20"
		DIE_100: die_name = "d100"
	
	return str("res://DicePNGs/white/", die_name,".png")
