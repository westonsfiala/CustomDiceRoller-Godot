extends Resource
class_name AbstractDie
	
var m_name : String = ""
var m_info : String = ""
var m_texture : Texture2D = preload("res://DicePNGs/basic/white/unknown-die.png")

const DIE_DISPLAY_IN_HEX : StringName = '0x'

func name() -> String:
	return m_name
	
func info() -> String:
	return m_info
	
func texture() -> Texture2D:
	return m_texture
	
func roll():
	assert(false, "roll - not implemented in AbstractDie")
	return
	
func is_numbered() -> bool:
	assert(false, "is_numbered - not implemented in AbstractDie")
	return false
	
func is_text() -> bool:
	assert(false, "is_text - not implemented in AbstractDie")
	return false
	
func is_image() -> bool:
	assert(false, "is_image - not implemented in AbstractDie")
	return false
	
