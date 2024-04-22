extends NumberDie
class_name MinMaxDie

@export var min_bound : int
@export var max_bound : int

const CLASS_NAME: StringName = "MinMaxDie"

# Generate the save state for our dice
func save_dict() -> Dictionary:
	var save_state: Dictionary = {}

	save_state['schema_version'] = "1.0.0"
	save_state['class_name'] = CLASS_NAME
	save_state['name'] = m_name
	save_state['override_image_path'] = override_image_path
	save_state['min_bound'] = min_bound
	save_state['max_bound'] = max_bound

	return save_state

# Creates a imbalanced die from the save state.
# If any errors occur, returns a null object.
static func load_from_save_dict(save_state: Dictionary) -> MinMaxDie:
	# Make sure we have all the necessary parts
	if not save_state.has('schema_version'):
		print("Missing schema_version during min_max_die loader")
		return null
	if not save_state.has('class_name'):
		print("Missing class_name during min_max_die loader")
		return null
	if not save_state.has('name'):
		print("Missing name during min_max_die loader")
		return null
	if not save_state.has('override_image_path'):
		print("Missing override_image_path during min_max_die loader")
		return null
	if not save_state.has('min_bound'):
		print("Missing min_bound during min_max_die loader")
		return null
	if not save_state.has('max_bound'):
		print("Missing max_bound during min_max_die loader")
		return null
		
	# Make sure we have the correct schema version, class_name, and other properties.
	if save_state['schema_version'] != '1.0.0':
		print("Unknown schema_version during min_max_die loader: ", save_state['schema_version'])
		return null
	if save_state['class_name'] != CLASS_NAME:
		print("Unknown class_name during min_max_die loader: ", save_state['class_name'])
		return null
	if not save_state['name'] is String:
		print("name not a string during min_max_die loader")
		return null
	if not save_state['override_image_path'] is String:
		print("override_image_path not a string during min_max_die loader")
		return null
	if not (save_state['min_bound'] is int or save_state['min_bound'] is float):
		print("min_bound not an int during min_max_die loader: ", typeof(save_state['min_bound']))
		return null
	if not (save_state['max_bound'] is int or save_state['min_bound'] is float):
		print("max_bound not an int during min_max_die loader: ", typeof(save_state['max_bound']))
		return null
		
	var new_die : MinMaxDie = MinMaxDie.new().configure(save_state['name'], save_state['min_bound'], save_state['max_bound'])
	new_die.override_image_path = save_state['override_image_path']
	return new_die

func configure(die_name: String, bound1: int, bound2: int) -> MinMaxDie:
	min_bound = min(bound1, bound2)
	max_bound = max(bound1, bound2)
	if(die_name.is_empty()):
		m_name = default_name()
	else:
		m_name = die_name
	return self
	
func get_class_name() -> StringName:
	return CLASS_NAME

func default_name() -> String:
	var placeholder_name : String = 'd'
	if(minimum() == 1):
		placeholder_name += str(maximum())
	else:
		placeholder_name += str(minimum(), ":", maximum())
	return placeholder_name

func info() -> String:
	return str('Rolls a number between ', min_bound, ' and ', max_bound, '\nAverage of ', average())

# Gets the image id. 
func image_id() -> int:
	var id : int = DieImageManager.DIE_UNKNOWN
	
	match minimum():
		-1: 
			match maximum():
				1: id = DieImageManager.DIE_FATE
		1:
			match maximum():
				2: id = DieImageManager.DIE_2
				3: id = DieImageManager.DIE_3
				4: id = DieImageManager.DIE_4
				6: id = DieImageManager.DIE_6
				8: id = DieImageManager.DIE_8
				10: id = DieImageManager.DIE_10
				12: id = DieImageManager.DIE_12
				20: id = DieImageManager.DIE_20
				100: id = DieImageManager.DIE_100
	
	return id

func roll() -> DieResult:
	var result : int = randi_range(min_bound, max_bound)
	return DieResult.new().configure(DieResult.DieResultType.INTEGER, result, minimum(), maximum())

func minimum() -> int:
	return min_bound

func maximum() -> int:
	return max_bound

func average() -> float:
	return (min_bound + max_bound)/2.0

func get_faces() -> Array:
	return range(minimum(), maximum()+1)
