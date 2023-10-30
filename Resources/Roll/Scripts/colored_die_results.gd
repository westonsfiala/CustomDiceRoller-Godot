extends Resource
class_name ColoredDieResults

@export var prepend_text : String
@export var append_text : String
@export var roll_min : int
@export var roll_max : int
@export var regular_rolls : Array
@export var struck_rolls : Array
@export var id : String

func configure(prepend: String, append: String, min: int, max: int, regular: Array, struck: Array, key: String) -> ColoredDieResults:
	prepend_text = prepend
	append_text = append
	roll_min = min
	roll_max = max
	regular_rolls = regular
	struck_rolls = struck
	id = key
	return self
