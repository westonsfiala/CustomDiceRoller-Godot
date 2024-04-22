extends Node

var default_min_max_die : MinMaxDie = MinMaxDie.new().configure("", 1, 20)
var default_imbalanced_die : ImbalancedDie = ImbalancedDie.new().configure("", [1,1,2,3,5])
var default_word_die : WordDie = WordDie.new().configure("", ["a","b","c","d"])

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

var simple_roll_dice : Array[AbstractDie]
var simple_roll_properties : RollProperties

const SAVE_FILE_NAME : StringName = "user://simple_roll_manager.save"

signal roll_properties_updated()
signal simple_dice_updated()

func _ready() -> void:
	load_state()
	
# Save the state of the simple roll manager to its save file.
func save_state() -> void:
	# Open the save file for writing.
	var simple_roll_save_file : FileAccess = FileAccess.open(SAVE_FILE_NAME, FileAccess.WRITE)
	
	# Start generating the save state dict.
	var save_dict : Dictionary = {}
	
	# Not sure if I need a schema version, but can't hurt to have.
	save_dict['schema_version'] = "1.0.0"
	save_dict['class_name'] = "SimpleRollManager"
	
	# Save the properties.
	save_dict['properties'] = simple_roll_properties.save_dict()
	
	# Save all of the dice.
	var dice_save_dict_array: Array = []
	for die : AbstractDie in simple_roll_dice:
		var die_save_dict : Dictionary = die.save_dict()
		dice_save_dict_array.push_back(die_save_dict)
	save_dict['dice'] = dice_save_dict_array
	
	# Turn the dict into a string.
	var json_string : String = JSON.stringify(save_dict)
	
	# Save it into the file
	simple_roll_save_file.store_line(json_string)
	
# Load our state from our save file.
func load_state() -> void:
	# Set some known good default valus that will be overridden later.
	simple_roll_dice = default_dice_array.duplicate()
	simple_roll_properties = RollProperties.new()
	
	# If not save file is present, use the defaults.
	if not FileAccess.file_exists(SAVE_FILE_NAME):
		print("No simple roll manager save file detected.")
		return
	
	# Load our save file and start parsing it.
	var simple_roll_save_file : FileAccess = FileAccess.open(SAVE_FILE_NAME, FileAccess.READ)
	while simple_roll_save_file.get_position() < simple_roll_save_file.get_length():
		
		# Grab a line and parse it. We should only ever have one line.
		var json_string : String = simple_roll_save_file.get_line()
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
			print("Missing schema_version during simple_roll_manager loader")
			return
		if not save_data.has('class_name'):
			print("Missing class_name during simple_roll_manager loader")
			return
		if not save_data.has('properties'):
			print("Missing properties during simple_roll_manager loader")
			return
		if not save_data.has('dice'):
			print("Missing dice during simple_roll_manager loader")
			return
			
		if save_data['schema_version'] != "1.0.0":
			print("Unknown schema_version found during simple_roll_manager loader: ", save_data['schema_version'])
			return
		if save_data['class_name'] != "SimpleRollManager":
			print("Unknown class_name found during simple_roll_manager loader: ", save_data['class_name'])
			return
		if not save_data['properties'] is Dictionary:
			print("properties is not a Dictionary during simple_roll_manager loader")
			return
		if not save_data['dice'] is Array:
			print("dice is not an Array during simple_roll_manager loader")
			return
		
		var properties_save_dict: Dictionary = save_data['properties']
		simple_roll_properties = RollProperties.load_from_save_dict(properties_save_dict)
		
		var dice_array_save_array: Array = save_data['dice']
		var loaded_dice : Array[AbstractDie] = DieLoaderFactory.load_from_array_of_save_dict(dice_array_save_array)
		if not loaded_dice.is_empty():
			simple_roll_dice = loaded_dice
		

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
	simple_roll_dice.sort_custom(func(left: AbstractDie, right: AbstractDie) -> bool: return left.average() < right.average())
	save_state()
	emit_signal("simple_dice_updated")
	
# Gets the index of the die given by name.
# If not found, returns -1.
func get_die_index_by_name(check_die : AbstractDie) -> int:
	var index : int = 0
	for die : AbstractDie in simple_roll_dice:
		if check_die.name() == die.name():
			return index
		index += 1
	return -1
	
# Checks if the given die already exists by checking its name.
func has_die_by_name(check_die : AbstractDie) -> bool:
	return get_die_index_by_name(check_die) != -1

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
		var die_index : int = get_die_index_by_name(die)
		simple_roll_dice.remove_at(die_index)
		if(not supress_update):
			set_dice(simple_roll_dice)
		return true
	return false

# Edits the original die, by removing it and attempting to add the new die.
# If the original is removed and the new is added returns true, else false.
func edit_die(original_die: AbstractDie, new_die: AbstractDie) -> bool:
	var edited : bool = false
	
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
	save_state()
	emit_signal("roll_properties_updated")

# Resets the roll properties to empty roll properties.
func reset_properties() -> void:
	set_roll_properties(RollProperties.new())
