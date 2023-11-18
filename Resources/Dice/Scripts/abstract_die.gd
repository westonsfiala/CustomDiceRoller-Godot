extends Resource
class_name AbstractDie
	
@export var m_name : String = ""
@export var m_info : String = ""
@export var override_image_path : String = ""

const DIE_DISPLAY_IN_HEX : StringName = '0x'

func name() -> String:
	return m_name
	
func default_name() -> String:
	assert(false, "default_name - not implemented in AbstractDie")
	return ""
	
func info() -> String:
	return m_info
	
func texture() -> Texture2D:
	if(override_image_path.is_empty()):
		return load(DieImageManager.get_die_image(image_id()))
	return load(override_image_path)
	
func image_id() -> int:
	assert(false, "image_id - not implemented in AbstractDie")
	return 0
	
func minimum() -> int:
	assert(false, "minimum - not implemented in AbstractDie")
	return 0
	
func maximum() -> int:
	assert(false, "maximum - not implemented in AbstractDie")
	return 0
	
func average() -> float:
	assert(false, "average - not implemented in AbstractDie")
	return -1.0
	
func get_faces() -> Array:
	assert(false, "get_faces - not implemented in AbstractDie")
	return []
	
func roll() -> DieResult:
	assert(false, "roll - not implemented in AbstractDie")
	return DieResult.new().configure(DieResult.DieResultType.INVALID,'','','')
	
func is_numbered() -> bool:
	assert(false, "is_numbered - not implemented in AbstractDie")
	return false
	
func is_text() -> bool:
	assert(false, "is_text - not implemented in AbstractDie")
	return false
	
func is_image() -> bool:
	assert(false, "is_image - not implemented in AbstractDie")
	return false
	
