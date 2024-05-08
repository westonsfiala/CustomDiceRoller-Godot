extends Resource
class_name ColoredDieResults

@export var formatted_text : String = ""

func configure(prepend: String, append: String, regular: Array, struck: Array) -> ColoredDieResults:
	formatted_text = prepend
	formatted_text += produce_list_text(regular)
	
	if(struck.size() != 0):
		formatted_text += " "
		formatted_text += strike_string(produce_list_text(struck))
	
	formatted_text += append
	return self

func bold_string(text: String) -> String:
	return str("[b]", text, "[/b]")
	
func strike_string(text: String) -> String:
	return str("[s]", text, "[/s]")
	
func color_string(text: String, color: String) -> String:
	return str("[color=", color, "]", text, "[/color]")
	
func produce_list_text(list: Array) -> String:
	var list_text : String = ""
	var first : bool = true
	for result : DieResult in list:
		if(not first):
			list_text += ", "
		first = false
		var result_value_string : String = str(result.value())
		
		# Only color the result if it is a maximum or minimum and highlighting is enabled
		var highlight_enabled : bool = SettingsManager.get_min_max_highlight_enabled()
		if(result.is_maximum() and highlight_enabled):
			list_text += color_string(result_value_string, "GREEN")
		elif(result.is_minimum() and highlight_enabled):
			list_text += color_string(result_value_string, "RED")
		else:
			list_text += result_value_string
	return list_text
	
