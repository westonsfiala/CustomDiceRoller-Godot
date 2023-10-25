extends Resource
class_name Roll

var m_roll_name : String = "TEMP"
var m_roll_category : String = "TEMP"
var m_die_prop_array : Array[DiePropertyPair] = []

func set_name_category(roll_name: String, roll_category: String):
	m_roll_name = roll_name
	m_roll_category = roll_category

# Checks to see if all of the dice in the roll are numbered
func is_numbers_only() -> bool:
	return m_die_prop_array.all(func(pair:DiePropertyPair): return pair.m_die.is_numbered())
	
func get_die_index(die: AbstractDie) -> int:
	var index = 0
	for die_prop_pair in m_die_prop_array:
		index += 1
		if(die_prop_pair.m_die.m_name == die.m_name):
			return index
	return -1
	
# Adds a die to a roll. If the die already exists, fails.
# Returns if the die has been added.
func add_die_to_roll(die: AbstractDie, properties: RollProperties) -> bool:
	var index = get_die_index(die)
	if(index != -1):
		return false
	var new_pair = DiePropertyPair.new()
	new_pair.configure(die.duplicate(), properties.duplicate())
	m_die_prop_array.push_back(new_pair)
	return true
