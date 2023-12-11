extends Resource
class_name DiePropertyPair

@export var m_die : AbstractDie
@export var m_roll_properties : RollProperties

# Generate the save state for our dice
func save_dict() -> Dictionary:
	var save_state: Dictionary = {}

	save_state['schema_version'] = "1.0.0"
	save_state['class_name'] = "DiePropertyPair"
	save_state['die'] = m_die.save_dict()
	save_state['roll_properties'] = m_roll_properties.save_dict()

	return save_state
	
# Load an array of save dicts.
static func load_from_save_dict_array(save_dict_array: Array) -> Array[DiePropertyPair]:
	var new_array: Array[DiePropertyPair] = []
	
	for save_state in save_dict_array:
		var loaded_die_prop_pair = load_from_save_dict(save_state)
		if loaded_die_prop_pair != null:
			new_array.push_back(loaded_die_prop_pair)
	
	return new_array

# Creates a DiePropertyPair from the save state.
# If any errors occur, returns a null object.
static func load_from_save_dict(save_state: Dictionary) -> DiePropertyPair:
	# Make sure we have all the necessary parts
	if not save_state.has('schema_version'):
		print("Missing schema_version during die_prop_pair loader")
		return null
	if not save_state.has('class_name'):
		print("Missing class_name during die_prop_pair loader")
		return null
	if not save_state.has('die'):
		print("Missing die during die_prop_pair loader")
		return null
	if not save_state.has('roll_properties'):
		print("Missing die during die_prop_pair loader")
		return null
		
	# Make sure we have the correct schema version, class_name, and other properties.
	if save_state['schema_version'] != '1.0.0':
		print("Unknown schema_version during die_prop_pair loader: ", save_state['schema_version'])
		return null
	if save_state['class_name'] != "DiePropertyPair":
		print("Unknown class_name during die_prop_pair loader: ", save_state['class_name'])
		return null
	if not save_state['die'] is Dictionary:
		print("die not a dictionary during die_prop_pair loader")
		return null
	if not save_state['roll_properties'] is Dictionary:
		print("roll_properties not a dictionary during die_prop_pair loader")
		return null
		
	var new_die_prop_pair = DiePropertyPair.new()
	var loaded_die = DieLoaderFactory.load_from_save_dict(save_state['die'])
	if loaded_die == null:
		print("Could not load die during die_prop_pair loader")
		return null
	var loaded_props = RollProperties.load_from_save_dict(save_state['roll_properties'])
	if loaded_props == null:
		print("Could not load properties during die_prop_pair loader")
		return null
	new_die_prop_pair.configure(loaded_die, loaded_props)
	return new_die_prop_pair

func configure(die: AbstractDie, roll_properties: RollProperties) -> DiePropertyPair:
	m_die = die
	m_roll_properties = roll_properties
	return self
