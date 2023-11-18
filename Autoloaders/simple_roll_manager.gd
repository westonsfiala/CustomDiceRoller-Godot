extends Node

var default_min_max_die : MinMaxDie = MinMaxDie.new().configure("", 1, 20)

var default_die : MinMaxDie = MinMaxDie.new().configure("TEMP", 1, 1)
var fate : MinMaxDie = MinMaxDie.new().configure("fate", -1, 1)
var d2 : MinMaxDie = MinMaxDie.new().configure("d2", 1, 2)
var d3 : MinMaxDie = MinMaxDie.new().configure("d3", 1, 3)
var d4 : MinMaxDie = MinMaxDie.new().configure("d4", 1, 4)
var d6 : MinMaxDie = MinMaxDie.new().configure("d6", 1, 6)
var d8 : MinMaxDie = MinMaxDie.new().configure("d8", 1, 8)
var d10 : MinMaxDie = MinMaxDie.new().configure("d10", 1, 10)
var d12 : MinMaxDie = MinMaxDie.new().configure("d12", 1, 12)
var d20 : MinMaxDie = MinMaxDie.new().configure("d20", 1, 20)
var d100 : MinMaxDie = MinMaxDie.new().configure("d100", 1, 100)
var default_dice_array : Array[AbstractDie] = [fate, d2, d3, d4, d6, d8, d10, d12, d20, d100]

var simple_roll_dice : Array[AbstractDie] = default_dice_array.duplicate(true)

var simple_roll_properties : RollProperties = RollProperties.new()

signal roll_properties_updated()
signal simple_dice_updated()

# Gets a default die, a d20. Can be useful when you just want a die, but don't care what it is.
func get_default_die() -> AbstractDie:
	return default_die

# Gets all dice managed by the simple roller.
func get_dice() -> Array[AbstractDie]:
	return simple_roll_dice
	
# Set the new array to be our managed dice and sorts them by average.
# It then signals to any listeners that the dice have been updated.
func set_dice(dice: Array[AbstractDie]) -> void:
	simple_roll_dice = dice
	simple_roll_dice.sort_custom(func(left: AbstractDie, right: AbstractDie): return left.average() < right.average())
	emit_signal("simple_dice_updated")
	
# Checks if the given die already exists by checking its name.
func has_die_by_name(check_die : AbstractDie) -> bool:
	for die in simple_roll_dice:
		if check_die.name() == die.name():
			return true
	return false

# Adds the given die to the managed dice. 
# If a die with the same name already exists, returns false.
# If suppress_update is set, will not trigger signals.
func add_die(die: AbstractDie, supress_update: bool = false) -> bool:
	if(has_die_by_name(die)):
		return false
	simple_roll_dice.push_back(die)
	if(not supress_update):
		set_dice(simple_roll_dice)
	return true

# Remove the given die from the managed dice.
# If no die exists with the given name, returns false.
# If suppress_update is set, will not trigger signals.
func remove_die(die: AbstractDie, supress_update: bool = false) -> bool:
	if(has_die_by_name(die)):
		var die_index = simple_roll_dice.find(die)
		simple_roll_dice.remove_at(die_index)
		if(not supress_update):
			set_dice(simple_roll_dice)
		return true
	return false

# Edits the original die, by removing it and attempting to add the new die.
# If the original is removed and the new is added returns true, else false.
func edit_die(original_die: AbstractDie, new_die: AbstractDie) -> bool:
	var edited = false
	
	if(remove_die(original_die, true)):
		if(add_die(new_die, true)):
			edited = true
		else:
			add_die(original_die, true)
			
	set_dice(simple_roll_dice)
	return edited

# Resets the dice to the default dice array.
func reset_dice() -> void:
	set_dice(default_dice_array.duplicate(true))

# Gets the simple roll properties.
func get_roll_properties() -> RollProperties:
	return simple_roll_properties
	
# Sets the roll properties to the given roll properties.
func set_roll_properties(roll_properties: RollProperties) -> void:
	simple_roll_properties = roll_properties
	emit_signal("roll_properties_updated")

# Resets the roll properties to empty roll properties.
func reset_properties() -> void:
	set_roll_properties(RollProperties.new())
