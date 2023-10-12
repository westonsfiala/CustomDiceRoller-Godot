extends Control

@export var dice_result : Label

func _set_dice_result(result: int):
	dice_result.text = str(result)
