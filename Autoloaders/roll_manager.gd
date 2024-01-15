extends Node

# history is stored in start->newest result->older result->end
var roll_history : Array[RollResults] = []
var cleared_roll_history : Array[RollResults] = []

const MAX_SAVED_HISTORY_ITEMS = 100
const SAVE_FILE_NAME : StringName = "user://roll_manager.save"

signal refresh_history()
signal new_roll_result(roll_result : RollResults)

# Load anything we have saved.
func _ready():
	load_state()
	
# Save the state of the simple roll manager to its save file.
func save_state() -> void:
	# Open the save file for writing.
	var history_save_file = FileAccess.open(SAVE_FILE_NAME, FileAccess.WRITE)
	
	# Start generating the save state dict.
	var save_dict : Dictionary = {}
	
	# Not sure if I need a schema version, but can't hurt to have.
	save_dict['schema_version'] = "1.0.0"
	save_dict['class_name'] = "RollManager"
	
	# Save the roll results.
	# Once we hit our cap of how many save items, save no more.
	var roll_results_save_dict_array: Array = []
	for roll_result in roll_history:
		var roll_result_save_dict = roll_result.save_dict()
		roll_results_save_dict_array.push_back(roll_result_save_dict)
		if(roll_results_save_dict_array.size() >= MAX_SAVED_HISTORY_ITEMS):
			break
	save_dict['roll_history'] = roll_results_save_dict_array
	
	# Turn the dict into a string.
	var json_string = JSON.stringify(save_dict)
	
	# Save it into the file
	history_save_file.store_line(json_string)
	
# Load our state from our save file.
func load_state() -> void:
	# If not save file is present, use the defaults.
	if not FileAccess.file_exists(SAVE_FILE_NAME):
		print("No roll manager save file detected.")
		return
	
	# Load our save file and start parsing it.
	var roll_manager_save_file = FileAccess.open(SAVE_FILE_NAME, FileAccess.READ)
	while roll_manager_save_file.get_position() < roll_manager_save_file.get_length():
		
		# Grab a line and parse it. We should only ever have one line.
		var json_string = roll_manager_save_file.get_line()
		var json = JSON.new()
		
		# If something goes wrong, print a message and bail.
		var parse_results = json.parse(json_string)
		if not parse_results == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return
		
		# Get the data from the JSON object
		var save_data: Dictionary = json.get_data()
		
		# Do some checking to make sure we have all our bits.
		if not save_data.has('schema_version'):
			print("Missing schema_version during roll_manager loader")
			return
		if not save_data.has('class_name'):
			print("Missing class_name during roll_manager loader")
			return
		if not save_data.has('roll_history'):
			print("Missing roll_history during roll_manager loader")
			return
			
		if save_data['schema_version'] != "1.0.0":
			print("Unknown schema_version found during roll_manager loader: ", save_data['schema_version'])
			return
		if save_data['class_name'] != "RollManager":
			print("Unknown class_name found during roll_manager loader: ", save_data['class_name'])
			return
		if not save_data['roll_history'] is Array:
			print("roll_history is not an Array during roll_manager loader")
			return
		
		var roll_history_save_array: Array = save_data['roll_history']
		roll_history = RollResults.load_from_array_of_save_dict(roll_history_save_array)

# Add a simple roll to the history.
func simple_roll(die : AbstractDie, props : RollProperties):
	var new_roll = Roll.new().configure("Simple Roll", "")
	new_roll.add_die_to_roll(die, props)
	var roll_results = new_roll.roll()
	add_to_history(roll_results)
	
# Produce a new roll results using an existing roll results
func reroll_from_results(roll_results: RollResults):
	var stored_roll = roll_results.stored_roll
	var new_results = stored_roll.roll()
	add_to_history(new_results)

# Adds a new roll to managed history.
# Sends out the "new_roll_result" signal.
func add_to_history(roll_result : RollResults):
	if(not cleared_roll_history.is_empty()):
		cleared_roll_history.clear()
		
	roll_history.push_front(roll_result)
	save_state()
	emit_signal("new_roll_result", roll_result)

# Gets the array of all stored results
func get_roll_history() -> Array[RollResults]:
	return roll_history
	
# Clears away the current roll results.
# Stores cleared results for potential undo.
# Emits the "refresh_history" signal.
func clear_roll_history():
	cleared_roll_history = roll_history.duplicate(true)
	roll_history.clear()
	save_state()
	emit_signal("refresh_history")
	
# Checks if we have cleared history to work with.
func has_cleared_history():
	return not cleared_roll_history.is_empty()
	
# Restores the roll history from the cleared roll history.
# Emits the "refresh_history" signal.
func restore_roll_history():
	roll_history = cleared_roll_history.duplicate(true)
	cleared_roll_history.clear()
	save_state()
	emit_signal("refresh_history")
