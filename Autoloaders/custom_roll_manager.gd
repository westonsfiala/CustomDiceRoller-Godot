extends Node

var custom_roll_die_prop_pairs : Array[DiePropertyPair]

const SAVE_FILE_NAME : StringName = "user://custom_roll_manager.save"

signal custom_roll_updated()

func _ready() -> void:
	load_state()
	
# Save the state of the custom roll manager to its save file.
func save_state() -> void:
	# Open the save file for writing.
	var custom_roll_save_file : FileAccess = FileAccess.open(SAVE_FILE_NAME, FileAccess.WRITE)
	
	# Start generating the save state dict.
	var save_dict : Dictionary = {}
	
	# Not sure if I need a schema version, but can't hurt to have.
	save_dict['schema_version'] = "1.0.0"
	save_dict['class_name'] = "CustomRollManager"
	
	# Save all of the die prop pairs
	var die_prop_save_dict_array: Array = []
	for die_prop_pair : DiePropertyPair in custom_roll_die_prop_pairs:
		var die_prop_save_dict : Dictionary = die_prop_pair.save_dict()
		die_prop_save_dict_array.push_back(die_prop_save_dict)
	save_dict['die_prop_pairs'] = die_prop_save_dict_array
	
	# Turn the dict into a string.
	var json_string : String = JSON.stringify(save_dict)
	
	# Save it into the file
	custom_roll_save_file.store_line(json_string)
	
# Load our state from our save file.
func load_state() -> void:
	# Set some known good default valus that will be overridden later.
	custom_roll_die_prop_pairs = []
	
	# If not save file is present, use the defaults.
	if not FileAccess.file_exists(SAVE_FILE_NAME):
		print("No custom roll manager save file detected.")
		return
	
	# Load our save file and start parsing it.
	var custom_roll_save_file : FileAccess = FileAccess.open(SAVE_FILE_NAME, FileAccess.READ)
	while custom_roll_save_file.get_position() < custom_roll_save_file.get_length():
		
		# Grab a line and parse it. We should only ever have one line.
		var json_string : String = custom_roll_save_file.get_line()
		var json : JSON = JSON.new()
		
		# If something goes wrong, print a message and bail.
		var parse_results : Error = json.parse(json_string)
		if not parse_results == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return
		
		# Get the data from the JSON object
		var save_data: Dictionary = json.get_data()
		
		# Do some checking to make sure we have all our bits.
		if not save_data.has('schema_version'):
			print("Missing schema_version during custom_roll_manager loader")
			return
		if not save_data.has('class_name'):
			print("Missing class_name during custom_roll_manager loader")
			return
		if not save_data.has('die_prop_pairs'):
			print("Missing die_prop_pairs during custom_roll_manager loader")
			return
			
		if save_data['schema_version'] != "1.0.0":
			print("Unknown schema_version found during custom_roll_manager loader: ", save_data['schema_version'])
			return
		if save_data['class_name'] != "CustomRollManager":
			print("Unknown class_name found during custom_roll_manager loader: ", save_data['class_name'])
			return
		if not save_data['die_prop_pairs'] is Array:
			print("die_prop_pairs is not a Dictionary during custom_roll_manager loader")
			return
		
		var die_prop_pairs_save_dict_array: Array = save_data['die_prop_pairs']
		custom_roll_die_prop_pairs = DiePropertyPair.load_from_save_dict_array(die_prop_pairs_save_dict_array)


# Gets all dice managed by the custom roller.
func get_die_prop_pairs() -> Array[DiePropertyPair]:
	return custom_roll_die_prop_pairs
	
# Set the new array to be our managed dice.
# It then signals to any listeners that the dice have been updated.
func set_die_prop_pairs(die_prop_pair_array: Array[DiePropertyPair]) -> void:
	custom_roll_die_prop_pairs = die_prop_pair_array
	save_state()
	emit_signal("custom_roll_updated")

# Adds the given die prop pair to the managed pairs. 
func add_die_prop_pair(die_prop_pair: DiePropertyPair) -> bool:
	custom_roll_die_prop_pairs.push_back(die_prop_pair)
	set_die_prop_pairs(custom_roll_die_prop_pairs)
	return true

# Adds a new die to the managed dice with default properties.
# Will not trigger update signal.
func add_die_to_custom_roll(die : AbstractDie) -> bool:
	var new_die_prop_pair : DiePropertyPair = DiePropertyPair.new()
	new_die_prop_pair.m_die = die
	new_die_prop_pair.m_roll_properties = RollProperties.new()
	return add_die_prop_pair(new_die_prop_pair)

# Remove the given die prop pairs from the managed dice.
# If invalid index is given, returns false.
func remove_die_prop_pair_from_index(index: int) -> bool:
	if(index < custom_roll_die_prop_pairs.size() and index >= 0):
		custom_roll_die_prop_pairs.remove_at(index)
		set_die_prop_pairs(custom_roll_die_prop_pairs)
		return true
	return false

# Updates the die prop pair at the given index with the new die prop pair.
func update_die_prop_pair_at_index(index: int, die_prop_pair: DiePropertyPair) -> bool:
	var edited : bool = false
	
	if(index < custom_roll_die_prop_pairs.size() and index >= 0):
		custom_roll_die_prop_pairs[index] = die_prop_pair
		edited = true
			
	set_die_prop_pairs(custom_roll_die_prop_pairs)
	return edited

# Move the die prop pair at the given index higher in the list.
func move_die_prop_pair_up(index: int) -> bool:
	if(index > 0 and index < custom_roll_die_prop_pairs.size()):
		var temp : DiePropertyPair = custom_roll_die_prop_pairs[index]
		custom_roll_die_prop_pairs.remove_at(index)
		custom_roll_die_prop_pairs.insert(index - 1, temp)
		set_die_prop_pairs(custom_roll_die_prop_pairs)
		return true
	return false

# Move the die prop pair at the given index lower in the list.
func move_die_prop_pair_down(index: int) -> bool:
	if(index >= 0 and index < custom_roll_die_prop_pairs.size() - 1):
		var temp : DiePropertyPair = custom_roll_die_prop_pairs[index]
		custom_roll_die_prop_pairs.remove_at(index)
		custom_roll_die_prop_pairs.insert(index + 1, temp)
		set_die_prop_pairs(custom_roll_die_prop_pairs)
		return true
	return false

# Resets the dice to the default dice prop array.
func reset_die_prop_pairs() -> void:
	set_die_prop_pairs([])
