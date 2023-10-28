extends Node

# Convert the value to a String with a +/- attached. 
# if hide_zero is set and the value is zero, return an empty String
func get_modifier_String(value: int, hide_zero: bool) -> String:
	if(hide_zero and value == 0):
		return ''
		
	var prefix = ''
	if(value >= 0):
		prefix = '+'
		
	return str(prefix, value)

func wrap_in_parens(wrapper) -> String:
	return str('(', wrapper, ')')

func decimal_to_string(decimal_number: float, decimalPlaces: int) -> String:
	var number_string = str(decimal_number)
	var number_split = number_string.split('.')

	if(number_split.length != 2 or number_split[1].length < decimalPlaces):
		return number_string

	return number_split[0] + '.' + number_split[1].substr(0, decimalPlaces)
