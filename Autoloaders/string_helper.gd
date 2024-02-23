extends Node

# Convert the value to a String with a +/- attached. 
# if hide_zero is set and the value is zero, return an empty String
func get_modifier_string(value: int, hide_zero: bool) -> String:
	if(hide_zero and value == 0):
		return ''
		
	var prefix = ''
	if(value >= 0):
		prefix = '+'
		
	return str(prefix, value)

func wrap_in_parens(wrapper) -> String:
	return str('(', wrapper, ')')

func decimal_to_string(decimal_number: float, decimal_places: int) -> String:
	var number_string = str(decimal_number)
	var number_split = number_string.split('.')
	
	if(number_split.size() != 2 or number_split[1].length() < decimal_places):
		return number_string
	
	# If we don't want anything past the decimal, don't put a decimal.
	if(decimal_places <= 0):
		return number_split[0]
		
	return number_split[0] + '.' + number_split[1].substr(0, decimal_places)
	
# Strips out [left][/left][center][/center][right][/right] from the provided string.
func strip_directional_bbcode(bbcode: String) -> String:
	var stripped_text = bbcode
	stripped_text = stripped_text.replace("[left]", "")
	stripped_text = stripped_text.replace("[/left]", "")
	stripped_text = stripped_text.replace("[center]", "")
	stripped_text = stripped_text.replace("[/center]", "")
	stripped_text = stripped_text.replace("[right]", "")
	stripped_text = stripped_text.replace("[/right]", "")
	return stripped_text
