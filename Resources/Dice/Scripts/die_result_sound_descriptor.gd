extends Node
class_name DieResultSoundDescriptor

@export var die_name : StringName = ""
@export var die_result : StringName = ""
@export var sound_id : StringName = ""

func configure(new_die_name: StringName, new_die_result: StringName, new_sound_id: StringName) -> DieResultSoundDescriptor:
	self.die_name = new_die_name
	self.die_result = new_die_result
	self.sound_id = new_sound_id
	return self

# Save our state to a dictionary.
func save_dict() -> Dictionary:
	var dict : Dictionary = {}
	dict["schema_version"] = "1.0.0"
	dict["die_name"] = die_name
	dict["die_result"] = die_result
	dict["sound_id"] = sound_id
	return dict

# Save an array of die result sound descriptors to an array of dictionaries.
static func save_array_of_descriptors(descriptors: Array[DieResultSoundDescriptor]) -> Array:
	var save_array : Array = []
	for descriptor : DieResultSoundDescriptor in descriptors:
		save_array.append(descriptor.save_dict())
	return save_array

# Creates a die result sound descriptor from a dictionary.
# If any errors occur, returns a null object.
static func load_from_save_dict(save_state: Dictionary) -> DieResultSoundDescriptor:
	# Make sure we have all the necessary parts
	if save_state['schema_version'] != '1.0.0':
		print("Unknown schema_version during die_result_sound_descriptor loader: ", save_state['schema_version'])
		return null
	if not (save_state['die_name'] is String or save_state['die_name'] is StringName):
		print("die_name not a string during die_result_sound_descriptor loader")
		return null
	if not (save_state['die_result'] is String or save_state['die_result'] is StringName):
		print("die_result not a string during die_result_sound_descriptor loader")
		return null
	if not (save_state['sound_id'] is String or save_state['sound_id'] is StringName):
		print("sound_id not an String during die_result_sound_descriptor loader")
		return null
		
	# Create the descriptor and return it
	var new_descriptor : DieResultSoundDescriptor = DieResultSoundDescriptor.new().configure(save_state['die_name'], save_state['die_result'], save_state['sound_id'])
	return new_descriptor

# Creates an array of die result sound descriptors from an array of dictionaries.
static func load_from_array_of_save_dict(save_dict_array: Array) -> Array[DieResultSoundDescriptor]:
	var loaded_descriptors : Array[DieResultSoundDescriptor] = []
	for saved_dict : Dictionary in save_dict_array:
		var loaded_descriptor : DieResultSoundDescriptor = DieResultSoundDescriptor.load_from_save_dict(saved_dict)
		if loaded_descriptor != null:
			loaded_descriptors.append(loaded_descriptor)
	return loaded_descriptors
