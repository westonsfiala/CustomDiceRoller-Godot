extends Resource
class_name CustomRollModel

@export var m_die_prop_pairs : Array[DiePropertyPair]
@export var m_name : String
@export var m_category : String

const CLASS_NAME : String = "CustomRollModel"
const SCHEMA_VERSION_KEY : String = "schema_version"
const CLASS_NAME_KEY : String = "class_name"
const DIE_PROP_PAIRS_KEY : String = "die_prop_pairs" 
const NAME_KEY : String = "name"
const CATEGORY_KEY : String = "category"

# Generate the save state for our custom roll model
func save_dict() -> Dictionary:
	var save_state: Dictionary = {}

	save_state[SCHEMA_VERSION_KEY] = "1.0.0"
	save_state[CLASS_NAME_KEY] = CLASS_NAME
	
	# Save all of the die prop pairs
	var die_prop_save_dict_array: Array = []
	for die_prop_pair : DiePropertyPair in m_die_prop_pairs:
		var die_prop_save_dict : Dictionary = die_prop_pair.save_dict()
		die_prop_save_dict_array.push_back(die_prop_save_dict)
	save_state[DIE_PROP_PAIRS_KEY] = die_prop_save_dict_array

	save_state[NAME_KEY] = m_name
	save_state[CATEGORY_KEY] = m_category

	return save_state
	
# Load an array of save dicts.
static func load_from_save_dict_array(save_dict_array: Array) -> Array[CustomRollModel]:
	var new_array: Array[CustomRollModel] = []
	
	for save_state : Dictionary in save_dict_array:
		var loaded_custom_roll_model : CustomRollModel = load_from_save_dict(save_state)
		if loaded_custom_roll_model != null:
			new_array.push_back(loaded_custom_roll_model)
	
	return new_array

# Creates a DiePropertyPair from the save state.
# If any errors occur, returns a null object.
static func load_from_save_dict(save_state: Dictionary) -> CustomRollModel:
	# Make sure we have all the necessary parts
	if not save_state.has(SCHEMA_VERSION_KEY):
		print("Missing schema_version during custom_roll_model loader")
		return null
	if not save_state.has(CLASS_NAME_KEY):
		print("Missing class_name during custom_roll_model loader")
		return null
	if not save_state.has(NAME_KEY):
		print("Missing name during custom_roll_model loader")
		return null
	if not save_state.has(CATEGORY_KEY):
		print("Missing category during custom_roll_model loader")
		return null
	if not save_state.has(DIE_PROP_PAIRS_KEY):
		print("Missing die_prop_pairs during custom_roll_model loader")
		return null
		
	# Make sure we have the correct schema version, class_name, and other properties.
	if save_state[SCHEMA_VERSION_KEY] != '1.0.0':
		print("Unknown schema_version during custom_roll_model loader: ", save_state[SCHEMA_VERSION_KEY])
		return null
	if save_state[CLASS_NAME_KEY] != CLASS_NAME:
		print("Unknown class_name during custom_roll_model loader: ", save_state[CLASS_NAME_KEY])
		return null
	if not save_state[NAME_KEY] is String:
		print("name not a String during custom_roll_model loader")
		return null
	if not save_state[CATEGORY_KEY] is String:
		print("category not a String during custom_roll_model loader")
		return null
	if not save_state[DIE_PROP_PAIRS_KEY] is Array:
		print("die_prop_pairs not a dictionary during custom_roll_model loader")
		return null
		
	var new_custom_roll_model : CustomRollModel = CustomRollModel.new()
	var name : String = save_state.get(NAME_KEY)
	var category : String = save_state.get(CATEGORY_KEY)
	var die_prop_pairs_save_dict_array: Array = save_state[DIE_PROP_PAIRS_KEY]
	
	var loaded_die_prop_pairs : Array[DiePropertyPair] = DiePropertyPair.load_from_save_dict_array(die_prop_pairs_save_dict_array)

	new_custom_roll_model.configure(name, category, loaded_die_prop_pairs)
	return new_custom_roll_model

func configure(name: String, category: String, die_prop_pairs: Array[DiePropertyPair]) -> CustomRollModel:
	m_name = name
	m_category = category
	m_die_prop_pairs = die_prop_pairs
	return self
