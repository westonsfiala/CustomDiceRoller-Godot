extends Resource
class_name RollProperties

const NUM_DICE : StringName = "NUM_DICE"
var num_dice : int = 1

const DICE_MODIFIER : StringName = "DICE_MODIFIER"
var dice_modifier : int = 0

func _init(props : Dictionary):
	if(props.has(NUM_DICE)):
		num_dice = props[NUM_DICE] 
		
	if(props.has(DICE_MODIFIER)):
		dice_modifier = props[DICE_MODIFIER]
