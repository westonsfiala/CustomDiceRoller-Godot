extends Resource
class_name Roll

var m_roll_name : String = "TEMP"
var m_roll_category : String = "TEMP"
var m_die_prop_array : Array[DiePropertyPair] = []

# Sets the name and category and returns itself.
func configure(roll_name: String, roll_category: String) -> Roll:
	m_roll_name = roll_name
	m_roll_category = roll_category
	return self

# Checks to see if all of the dice in the roll are numbered
func is_numbers_only() -> bool:
	return m_die_prop_array.all(func(pair:DiePropertyPair): return pair.m_die.is_numbered())
	
# Returns the index of the die in the array. Compares dice by name only. 
# If the die is not found, returns -1.
func get_die_index(die: AbstractDie) -> int:
	var index = 0
	for die_prop_pair in m_die_prop_array:
		index += 1
		if(die_prop_pair.m_die.m_name == die.m_name):
			return index
	return -1

# Returns if the die is in the roll.
func contains_die(die: AbstractDie) -> bool:
	return get_die_index(die) != -1
	
# Adds a die to a roll. If the die already exists, fails.
# Returns if the die has been added.
func add_die_to_roll(die: AbstractDie, properties: RollProperties) -> bool:
	if(contains_die(die)):
		return false
	var new_pair = DiePropertyPair.new().configure(die.duplicate(true), properties.duplicate(true))
	m_die_prop_array.push_back(new_pair)
	return true
	
# Removes a die from a roll along with its associated properties.
# Returns if the die has been removed.
func remove_die_from_roll(die: AbstractDie) -> bool:
	var index = get_die_index(die)
	if(index == -1):
		return false
	m_die_prop_array.remove_at(index)
	return true

# overrides the old_die with the new_die. If new_die already exists, fails.
# Returns if the die has been overwritten.
func override_die_in_roll(old_die: AbstractDie, new_die: AbstractDie) -> bool:
	var old_index = get_die_index(old_die)
	var new_index = get_die_index(new_die)
	if(old_index == -1 or new_index != -1):
		return false
	var overwrite_die_prop_pair = m_die_prop_array[old_index]
	overwrite_die_prop_pair.configure(new_die.duplicate(true), overwrite_die_prop_pair.m_roll_properties)
	return true

# Get the number of dice in the roll by accumulating all of the num_dice properties
func get_total_dice_in_roll() -> int:
	return m_die_prop_array.reduce(
		func(accum,die_prop_pair): return die_prop_pair.m_roll_properties.get_property(RollProperties.NUM_DICE_IDENTIFIER), 
		0)


