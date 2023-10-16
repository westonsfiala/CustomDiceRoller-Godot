extends Node

var roll_history : Array[String] = []

signal new_roll_result(result : String)

func simple_roll(die : AbstractDie, props : RollProperties):
	if(die.is_numbered()):
		var roll_result = props.dice_modifier
		for i in props.num_dice:
			roll_result += die.roll()
		roll_history.push_back(str(roll_result))
		emit_signal("new_roll_result", str(roll_result))

func get_roll_history() -> Array[String]:
	return roll_history
