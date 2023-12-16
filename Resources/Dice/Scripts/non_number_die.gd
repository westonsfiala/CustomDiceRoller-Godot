extends AbstractDie
class_name NonNumberDie
	
func is_numbered() -> bool:
	return false

func is_text() -> bool:
	assert(false, "is_text - not implemented in NonNumberDie")
	return false

func is_image() -> bool:
	assert(false, "is_image - not implemented in NonNumberDie")
	return false
	
func minimum() -> int:
	return -1

func maximum() -> int:
	return -1

func average() -> float:
	return -1
	
