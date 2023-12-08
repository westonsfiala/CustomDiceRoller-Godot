extends Node

# Load an array of dice from an array of dice save dicts.
# If no dice can be created returns an empty list.
func load_from_array_of_save_dict(array_of_dice_save_dicts: Array) -> Array[AbstractDie]:
	var loaded_dice: Array[AbstractDie] = []
	
	# Go through all of the save dicts and try loading them
	for save_dict in array_of_dice_save_dicts:
		var new_die = load_from_save_dict(save_dict)
		
		# If a die was actually created, add it.
		if new_die != null:
			loaded_dice.push_back(new_die)

	return loaded_dice

# Load a single die from a save dict. On error, returns null.
func load_from_save_dict(save_dict: Dictionary) -> AbstractDie:
	# We need class_name to determine which dice to try and make.
	if not save_dict.has('class_name'):
		return null
	
	# Go through all of our constructable dice and try to make the die.
	var new_die: AbstractDie
	match save_dict['class_name']:
		ImbalancedDie.CLASS_NAME:
			new_die = ImbalancedDie.load_from_save_dict(save_dict)
		MinMaxDie.CLASS_NAME:
			new_die = MinMaxDie.load_from_save_dict(save_dict)
			
	return new_die
