extends TextureButton

@export var roll_minimum : int = 1
@export var roll_maximum : int = 20
@export var dice_image : Texture2D

func _ready():
	texture_normal = dice_image

func _on_pressed():
	var dice_result = randi_range(roll_minimum, roll_maximum)
	get_node("/root/Main")._set_dice_result(dice_result)
