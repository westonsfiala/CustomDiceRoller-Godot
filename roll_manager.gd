extends Node

var roll_history : Array[String] = []
var cleared_roll_history : Array[String] = []

signal new_roll_result(result : String)
signal refresh_history()

func simple_roll(die : AbstractDie, props : RollProperties):
	if(die.is_numbered()):
		var roll_result = props.dice_modifier
		for i in props.num_dice:
			roll_result += die.roll()
		add_to_history(str(roll_result))

func add_to_history(result : String):
	if(not cleared_roll_history.is_empty()):
		cleared_roll_history.clear()
		
	roll_history.push_back(result)
	emit_signal("new_roll_result", result)

func get_roll_history() -> Array[String]:
	return roll_history
	
func clear_roll_history():
	cleared_roll_history = roll_history.duplicate()
	roll_history.clear()
	emit_signal("refresh_history")
	
func has_cleared_history():
	return not cleared_roll_history.is_empty()
	
func restore_roll_history():
	roll_history = cleared_roll_history.duplicate()
	cleared_roll_history.clear()
	emit_signal("refresh_history")
