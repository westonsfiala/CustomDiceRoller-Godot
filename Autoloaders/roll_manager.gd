extends Node

var roll_history : Array[RollResults] = []
var cleared_roll_history : Array[RollResults] = []

signal refresh_history()
signal new_roll_result(roll_result : RollResults)

func simple_roll(die : AbstractDie, props : RollProperties):
	var new_roll = Roll.new().configure("Simple Roll", "")
	new_roll.add_die_to_roll(die, props)
	var roll_results = new_roll.roll()
	add_to_history(roll_results)

func add_to_history(roll_result : RollResults):
	if(not cleared_roll_history.is_empty()):
		cleared_roll_history.clear()
		
	roll_history.push_back(roll_result)
	emit_signal("new_roll_result", roll_result)

func get_roll_history() -> Array[RollResults]:
	return roll_history
	
func clear_roll_history():
	cleared_roll_history = roll_history.duplicate(true)
	roll_history.clear()
	emit_signal("refresh_history")
	
func has_cleared_history():
	return not cleared_roll_history.is_empty()
	
func restore_roll_history():
	roll_history = cleared_roll_history.duplicate(true)
	cleared_roll_history.clear()
	emit_signal("refresh_history")
