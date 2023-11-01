extends Resource
class_name AbstractDie
	
@export var m_name : String = ""
@export var m_info : String = ""
@export var m_texture : Texture2D = preload("res://DicePNGs/basic/white/unknown-die.png")

const DIE_DISPLAY_IN_HEX : StringName = '0x'

func name() -> String:
	return m_name
	
func info() -> String:
	return m_info
	
func texture() -> Texture2D:
	return m_texture
	
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
	
