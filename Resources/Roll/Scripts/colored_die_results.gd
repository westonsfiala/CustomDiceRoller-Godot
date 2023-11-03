extends Resource
class_name ColoredDieResults

@export var prepend_text : String
@export var append_text : String
@export var roll_min : int
@export var roll_max : int
@export var regular_rolls : Array #[DieResult]
@export var struck_rolls : Array #[DieResult]
@export var id : String

func configure(prepend: String, append: String, minimum: int, maximum: int, regular: Array, struck: Array, key: String) -> ColoredDieResults:
	prepend_text = prepend
	append_text = append
	roll_min = minimum
	roll_max = maximum
	regular_rolls = regular
	struck_rolls = struck
	id = key
	return self

func bold_string(text: String) -> String:
	return str("[b]", text, "[/b]")
	
func strike_string(text: String) -> String:
	return str("[s]", text, "[/s]")
	
func color_string(text: String, color: String) -> String:
	return str("[color=", color, "]", text, "[/color]")
	
func produce_list_text(list: Array) -> String:
	var list_text = ""
	var first = true
	for result in list:
		if(not first):
			list_text += ", "
		var result_value_string = str(result.value())
		if(result.is_maximum()):
			list_text += color_string(result_value_string, "GREEN")
		elif(result.is_minimum()):
			list_text += color_string(result_value_string, "RED")
		else:
			list_text += result_value_string
	return list_text

func rich_text() -> String:
	var formatted_text : String = prepend_text
	
	formatted_text += produce_list_text(regular_rolls)
	
	if(struck_rolls.size() != 0):
		formatted_text += " "
		formatted_text += strike_string(produce_list_text(struck_rolls))
	
	formatted_text += append_text
	return formatted_text
	
