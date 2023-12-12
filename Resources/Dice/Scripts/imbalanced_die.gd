extends NumberDie
class_name ImbalancedDie

@export var m_faces : Array[int]

const CLASS_NAME: StringName = "ImbalancedDie"

# Generate the save state for our dice
func save_dict() -> Dictionary:
	var save_state: Dictionary = {}

	save_state['schema_version'] = "1.0.0"
	save_state['class_name'] = CLASS_NAME
	save_state['name'] = m_name
	save_state['override_image_path'] = override_image_path
	save_state['faces'] = m_faces

	return save_state

# Creates a imbalanced die from the save state.
# If any errors occur, returns a null object.
static func load_from_save_dict(save_state: Dictionary) -> ImbalancedDie:
	# Make sure we have all the necessary parts
	if not save_state.has('schema_version'):
		print("Missing schema_version during imbalanced_die loader")
		return null
	if not save_state.has('class_name'):
		print("Missing class_name during imbalanced_die loader")
		return null
	if not save_state.has('name'):
		print("Missing name during imbalanced_die loader")
		return null
	if not save_state.has('override_image_path'):
		print("Missing override_image_path during imbalanced_die loader")
		return null
	if not save_state.has('faces'):
		print("Missing faces during imbalanced_die loader")
		return null
		
	# Make sure we have the correct schema version, class_name, and other properties.
	if save_state['schema_version'] != '1.0.0':
		print("Unknown schema_version during imbalanced_die loader: ", save_state['schema_version'])
		return null
	if save_state['class_name'] != CLASS_NAME:
		print("Unknown class_name during imbalanced_die loader: ", save_state['class_name'])
		return null
	if not save_state['name'] is String:
		print("name not a string during imbalanced_die loader")
		return null
	if not save_state['override_image_path'] is String:
		print("override_image_path not a string during imbalanced_die loader")
		return null
	if not save_state['faces'] is Array:
		print("faces not an array during imbalanced_die loader")
		return null
		
	var face_int_array: Array[int] = []
	for face_value in save_state['faces']:
		face_int_array.push_back(int(face_value))
	var new_die = ImbalancedDie.new().configure(save_state['name'], face_int_array)
	new_die.override_image_path = save_state['override_image_path']
	return new_die

func configure(die_name: String, faces: Array[int]) -> ImbalancedDie:
	m_faces = faces
	if(die_name.is_empty()):
		m_name = default_name()
	else:
		m_name = die_name
	
	return self
	
func get_class_name() -> StringName:
	return CLASS_NAME
	
func default_name() -> String:
	var placeholder_name = 'd'
	placeholder_name += m_faces.reduce(func(a,b): return str(a, b, ':'), "")
	placeholder_name = placeholder_name.trim_suffix(':')
	return placeholder_name

func info() -> String:
	return str('Rolls one of the following: ', m_faces, '\nAverage of ', average())
	
func image_id() -> int:
	return DieImageManager.DIE_UNKNOWN

func roll() -> DieResult:
	var result = m_faces.pick_random()
	return DieResult.new().configure(DieResult.DieResultType.INTEGER, result, minimum(), maximum())

func minimum() -> int:
	return m_faces.min()

func maximum() -> int:
	return m_faces.max()

func average() -> float:
	if(m_faces.size() == 0):
		return 0
	return m_faces.reduce(func(a,b): return a+b,0) / m_faces.size()

func get_faces() -> Array:
	return m_faces
