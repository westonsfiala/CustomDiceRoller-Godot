extends Node

var roll_history : Array[String] = []
var cleared_roll_history : Array[String] = []

signal refresh_history()
signal new_roll_result(result : String)

func simple_roll(die : AbstractDie, props : RollProperties):
	var new_roll = Roll.new().configure("Simple Roll", "")
	new_roll.add_die_to_roll(die, props)
	var results = new_roll.roll()
	add_to_history(results.roll_sum.rich_text())

func add_to_history(result : String):
	if(not cleared_roll_history.is_empty()):
		cleared_roll_history.clear()
		
	roll_history.push_back(result)
	emit_signal("new_roll_result", result)

func get_roll_history() -> Array[String]:
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
