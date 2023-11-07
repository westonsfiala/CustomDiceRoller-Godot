extends Node

var simple_roll_properties : RollProperties = RollProperties.new()

signal roll_properties_updated()

func get_roll_properties() -> RollProperties:
	return simple_roll_properties
	
func set_roll_properties(roll_properties: RollProperties) -> void:
	simple_roll_properties = roll_properties
	emit_signal("roll_properties_updated")
	
func reset_properties() -> void:
	set_roll_properties(RollProperties.new())
