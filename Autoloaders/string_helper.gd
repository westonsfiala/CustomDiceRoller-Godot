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

func get_num_dice_String(num_dice : int) -> String:
	return str(num_dice, 'd')

func get_repeat_roll_String(repeat : int) -> String:
	return str('Repeat ', repeat, ' Times')

func get_drop_highest_String(drop : int) -> String:
	return str('Drop ', drop, ' Highest')

func get_drop_low_String(drop : int) -> String:
	return str('Drop ', drop, ' Lowest')

func get_keep_high_String(keep : int) -> String:
	return str('Keep ', keep, ' Highest')

func get_keep_low_String(keep : int) -> String:
	return str('Keep ', keep, ' Lowest')

func get_reroll_String(reroll : int) -> String:
	return str('Re-Roll Die <= |', reroll, '|')

func get_minimum_String(minimum : int) -> String:
	return str('Minimum Value = |', minimum, '|')

func get_count_above_equal_String(countAboveEqual : int) -> String:
	return str('Count >= |', countAboveEqual, '|')

func get_repeat_roll_title() -> String:
	return 'Repeat X Times'

func get_drop_high_title() -> String:
	return 'Drop X Highest'

func get_drop_low_title() -> String:
	return 'Drop X Lowest'

func get_keep_high_title() -> String:
	return 'Keep X Highest'

func get_keep_low_title() -> String:
	return 'Keep X Lowest'

func get_reroll_title() -> String:
	return 'Re-Roll Die <= |X|'

func get_minimum_title() -> String:
	return 'Minimum Value = |X|'

func get_count_above_equal_title() -> String:
	return 'Count >= |X|'

func decimal_to_string(decimal_number: float, decimalPlaces: int) -> String:
	var number_string = str(decimal_number)
	var number_split = number_string.split('.')

	if(number_split.length != 2 or number_split[1].length < decimalPlaces):
		return number_string

	return number_split[0] + '.' + number_split[1].substr(0, decimalPlaces)
