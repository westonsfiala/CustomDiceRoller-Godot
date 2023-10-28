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

func get_num_dice_string(num_dice : int) -> String:
	return str(num_dice, 'd')

func get_repeat_roll_string(repeat : int) -> String:
	return str('Repeat ', repeat, ' Times')

func get_drop_highest_string(drop : int) -> String:
	return str('Drop ', drop, ' Highest')

func get_drop_lowest_string(drop : int) -> String:
	return str('Drop ', drop, ' Lowest')

func get_keep_highest_string(keep : int) -> String:
	return str('Keep ', keep, ' Highest')

func get_keep_lowest_string(keep : int) -> String:
	return str('Keep ', keep, ' Lowest')

func get_reroll_over_string(reroll_under : int) -> String:
	return str('Re-Roll Die >= |', reroll_under, '|')

func get_reroll_under_string(reroll_over : int) -> String:
	return str('Re-Roll Die <= |', reroll_over, '|')

func get_minimum_string(minimum : int) -> String:
	return str('Minimum Value = |', minimum, '|')

func get_maximum_string(maximum : int) -> String:
	return str('Maximum Value = |', maximum, '|')

func get_count_above_equal_string(count_above_equal : int) -> String:
	return str('Count >= |', count_above_equal, '|')

func get_count_below_equal_string(count_below_equal : int) -> String:
	return str('Count <= |', count_below_equal, '|')
	
func wrap_in_parens(wrapper) -> String:
	return str('(', wrapper, ')')

func get_advantage_title() -> String:
	return 'Advantage'
	
func get_disadvantage_title() -> String:
	return 'Disadvantage'
	
func get_double_title() -> String:
	return 'Double'
	
func get_halve_title() -> String:
	return 'Halve'
	
func get_repeat_roll_title() -> String:
	return 'Repeat X Times'

func get_drop_highest_title() -> String:
	return 'Drop X Highest'

func get_drop_lowest_title() -> String:
	return 'Drop X Lowest'

func get_keep_highest_title() -> String:
	return 'Keep X Highest'

func get_keep_lowest_title() -> String:
	return 'Keep X Lowest'

func get_reroll_over_title() -> String:
	return 'Re-Roll Die >= |X|'

func get_reroll_under_title() -> String:
	return 'Re-Roll Die <= |X|'

func get_maximum_title() -> String:
	return 'Maximum Value = |X|'

func get_minimum_title() -> String:
	return 'Minimum Value = |X|'

func get_count_above_equal_title() -> String:
	return 'Count >= |X|'

func get_count_below_equal_title() -> String:
	return 'Count <= |X|'

func get_explode_title() -> String:
	return str('Explode')

func decimal_to_string(decimal_number: float, decimalPlaces: int) -> String:
	var number_string = str(decimal_number)
	var number_split = number_string.split('.')

	if(number_split.length != 2 or number_split[1].length < decimalPlaces):
		return number_string

	return number_split[0] + '.' + number_split[1].substr(0, decimalPlaces)
