extends AbstractDie
class_name NumberDie

func is_numbered() -> bool:
	return true

func is_text() -> bool:
	return false

func is_image() -> bool:
	return false

func minimum() -> int:
	assert(false, "minimum - not implemented in NumberDie")
	return -1

func maximum() -> int:
	assert(false, "maximum - not implemented in NumberDie")
	return -1

func average() -> float:
	assert(false, "average - not implemented in NumberDie")
	return -1.0
