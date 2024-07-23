extends Node

var saved_rolls_array : Array[CustomRollModel]

const SAVE_FILE_NAME : StringName = "user://saved_roll_manager.save"
const CLASS_NAME : String = "SavedRollManager"
const CLASS_NAME_KEY : String = "class_name"
const SCHEMA_VERSION_KEY : String = "schema_version"
const SAVED_ROLLS_KEY : String = "saved_rolls"

signal saved_roll_updated()

func _ready() -> void:
	load_state()
	
# Save the state of the saved roll manager to its save file.
func save_state() -> void:
	# Open the save file for writing.
	var saved_roll_save_file : FileAccess = FileAccess.open(SAVE_FILE_NAME, FileAccess.WRITE)
	
	# Start generating the save state dict.
	var save_dict : Dictionary = {}
	
	# Not sure if I need a schema version, but can't hurt to have.
	save_dict[SCHEMA_VERSION_KEY] = "1.0.0"
	save_dict[CLASS_NAME_KEY] = CLASS_NAME
	
	# Save all of the die prop pairs
	var custom_roll_model_save_dict_array: Array = []
	for custom_roll_model : CustomRollModel in saved_rolls_array:
		var custom_roll_model_save_dict : Dictionary = custom_roll_model.save_dict()
		custom_roll_model_save_dict_array.push_back(custom_roll_model_save_dict)
	save_dict[SAVED_ROLLS_KEY] = custom_roll_model_save_dict_array
	
	# Turn the dict into a string.
	var json_string : String = JSON.stringify(save_dict)
	
	# Save it into the file
	saved_roll_save_file.store_line(json_string)
	
# Load our state from our save file.
func load_state() -> void:
	# Set some known good default valus that will be overridden later.
	saved_rolls_array = []
	
	# If not save file is present, use the defaults.
	if not FileAccess.file_exists(SAVE_FILE_NAME):
		print("No saved roll manager save file detected.")
		return
	
	# Load our save file and start parsing it.
	var saved_roll_save_file : FileAccess = FileAccess.open(SAVE_FILE_NAME, FileAccess.READ)
	while saved_roll_save_file.get_position() < saved_roll_save_file.get_length():
		
		# Grab a line and parse it. We should only ever have one line.
		var json_string : String = saved_roll_save_file.get_line()
		var json : JSON = JSON.new()
		
		# If something goes wrong, print a message and bail.
		var parse_results : Error = json.parse(json_string)
		if not parse_results == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return
		
		# Get the data from the JSON object
		var save_data: Dictionary = json.get_data()
		
		# Do some checking to make sure we have all our bits.
		if not save_data.has(SCHEMA_VERSION_KEY):
			print("Missing schema_version during saved_roll_manager loader")
			return
		if not save_data.has(CLASS_NAME_KEY):
			print("Missing class_name during saved_roll_manager loader")
			return
		if not save_data.has(SAVED_ROLLS_KEY):
			print("Missing saved_rolls during saved_roll_manager loader")
			return
			
		if save_data[SCHEMA_VERSION_KEY] != "1.0.0":
			print("Unknown schema_version found during saved_roll_manager loader: ", save_data['schema_version'])
			return
		if save_data[CLASS_NAME_KEY] != CLASS_NAME:
			print("Unknown class_name found during saved_roll_manager loader: ", save_data['class_name'])
			return
		if not save_data[SAVED_ROLLS_KEY] is Array:
			print("saved_rolls is not an array during saved_roll_manager loader")
			return
		
		var saved_rolls_save_dict_array: Array = save_data[SAVED_ROLLS_KEY]
		saved_rolls_array = CustomRollModel.load_from_save_dict_array(saved_rolls_save_dict_array)

# Get the saved rolls stored in the manager
func get_saved_rolls() -> Array[CustomRollModel]:
	return saved_rolls_array
