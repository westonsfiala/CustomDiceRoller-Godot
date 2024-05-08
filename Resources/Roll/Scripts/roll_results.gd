extends Resource
class_name RollResults

# variables that we care about after processing a roll
@export var time_string : String = ""
@export var date_string : String = ""
@export var stored_roll : Roll = Roll.new()
@export var roll_name_text : String = ""
@export var roll_detailed_name_text : String = ""
@export var roll_sum : ColoredDieResults = ColoredDieResults.new()
@export var roll_results_array : Array[ColoredDieResults] = []

# Variables that are only used internally to process a roll.
# Each of these maps is of type <String, Array<Variant>>
# The map string should be in the form: JSON.stringify(die)
var m_roll_results : Dictionary = {}
var m_dropped_rolls : Dictionary = {}
var m_rerolled_rolls : Dictionary = {}

var m_struck_roll_results : Dictionary = {}
var m_struck_dropped_rolls : Dictionary = {}
var m_struck_rerolled_rolls : Dictionary = {}

# The roll properties of each die in the form <String, RollProperties>
# Use the same keys as above for access.
var m_roll_properties : Dictionary = {}

# Generate the save state for our roll result
func save_dict() -> Dictionary:
	var save_state: Dictionary = {}

	save_state['schema_version'] = "1.0.0"
	save_state['class_name'] = 'RollResults'
	save_state['time_string'] = time_string
	save_state['date_string'] = date_string
	save_state['stored_roll'] = stored_roll.save_dict()
	save_state['roll_name_text'] = roll_name_text
	save_state['roll_detailed_name_text'] = roll_detailed_name_text
	save_state['roll_sum'] = roll_sum.formatted_text
	
	var roll_results_save_array: Array = []
	for roll_result : ColoredDieResults in roll_results_array:
		roll_results_save_array.push_back(roll_result.formatted_text)
	save_state['roll_results_array'] = roll_results_save_array

	return save_state

# Load an array of dice from an array of dice save dicts.
# If no dice can be created returns an empty list.
static func load_from_array_of_save_dict(array_of_roll_results_save_dicts: Array) -> Array[RollResults]:
	var loaded_results: Array[RollResults] = []
	
	# Go through all of the save dicts and try loading them
	for save_state : Dictionary in array_of_roll_results_save_dicts:
		var new_history : RollResults = load_from_save_dict(save_state)
		
		# If a die was actually created, add it.
		if new_history != null:
			loaded_results.push_back(new_history)

	return loaded_results

# Creates a RollResults from the save state.
# If any errors occur, returns a null object.
static func load_from_save_dict(save_state: Dictionary) -> RollResults:
	# Make sure we have all the necessary parts
	if not save_state.has('schema_version'):
		print("Missing schema_version during roll_results loader")
		return null
	if not save_state.has('class_name'):
		print("Missing class_name during roll_results loader")
		return null
	if not save_state.has('time_string'):
		print("Missing time_string during roll_results loader")
		return null
	if not save_state.has('date_string'):
		print("Missing date_string during roll_results loader")
		return null
	if not save_state.has('stored_roll'):
		print("Missing stored_roll during roll_results loader")
		return null
	if not save_state.has('roll_name_text'):
		print("Missing roll_name_text during roll_results loader")
		return null
	if not save_state.has('roll_detailed_name_text'):
		print("Missing roll_detailed_name_text during roll_results loader")
		return null
	if not save_state.has('roll_sum'):
		print("Missing roll_sum during roll_results loader")
		return null
	if not save_state.has('roll_results_array'):
		print("Missing roll_results_array during roll_results loader")
		return null
		
	# Make sure we have the correct schema version, class_name, and other properties.
	if save_state['schema_version'] != '1.0.0':
		print("Unknown schema_version during roll_results loader: ", save_state['schema_version'])
		return null
	if save_state['class_name'] != 'RollResults':
		print("Unknown class_name during roll_results loader: ", save_state['class_name'])
		return null
	if not save_state['time_string'] is String:
		print("time_string not a string during roll_results loader")
		return null
	if not save_state['date_string'] is String:
		print("date_string not a string during roll_results loader")
		return null
	if not save_state['stored_roll'] is Dictionary:
		print("stored_roll not a dictionary during roll_results loader")
		return null
	if not save_state['roll_name_text'] is String:
		print("roll_name_text not a string during roll_results loader")
		return null
	if not save_state['roll_detailed_name_text'] is String:
		print("roll_detailed_name_text not a string during roll_results loader")
		return null
	if not save_state['roll_sum'] is String:
		print("roll_sum not a string during roll_results loader")
		return null
	if not save_state['roll_results_array'] is Array:
		print("roll_results_array not an array during roll_results loader")
		return null
		
	var new_roll_results : RollResults = RollResults.new()
	new_roll_results.time_string = save_state['time_string']
	new_roll_results.date_string = save_state['date_string']
	var new_roll : Roll = Roll.load_from_save_dict(save_state['stored_roll'])
	if new_roll == null:
		print("Could not load roll during roll_results loader")
		return null
	new_roll_results.stored_roll = new_roll
	new_roll_results.roll_name_text = save_state['roll_name_text']
	new_roll_results.roll_detailed_name_text = save_state['roll_detailed_name_text']
	var new_roll_sum : ColoredDieResults = ColoredDieResults.new()
	new_roll_sum.formatted_text = save_state['roll_sum']
	new_roll_results.roll_sum = new_roll_sum
	var new_roll_results_array: Array[ColoredDieResults] = []
	for result_line : String in save_state['roll_results_array']:
		var new_result : ColoredDieResults = ColoredDieResults.new()
		new_result.formatted_text = result_line
		new_roll_results_array.push_back(new_result)
	new_roll_results.roll_results_array = new_roll_results_array
		
	return new_roll_results

# Tiny function used to help the reduce method
func simple_summer(accum : int, value : int) -> int: return accum + value
func die_summer(accum : int, die_result: DieResult) -> int: return accum + die_result.value()

func process_roll(roll: Roll) -> void:
	stored_roll = roll
	date_string = Time.get_date_string_from_system()
	time_string = Time.get_time_string_from_system()
	
	roll_name_text = roll.roll_name()
	roll_detailed_name_text = roll.get_detailed_roll_name()
	
	var sum_results : Array[int] = []
	var non_number_results : Array = []
	var show_split_sums : bool = false

	# Go through all of the dice in the roll and start making the roll detail lines
	for die : AbstractDie in get_merged_keys():
		
		# Sort the results if we need to
		if(SettingsManager.get_sort_type() == SettingsManager.SORT_TYPE.ASCENDING):
			sort_all_ascending()
		elif(SettingsManager.get_sort_type() == SettingsManager.SORT_TYPE.DESCENDING):
			sort_all_descending()
		
		var die_roll_results : Array = m_roll_results.get(die, [])
		var die_dropped_results : Array = m_dropped_rolls.get(die, [])
		var die_rerolled_results : Array = m_rerolled_rolls.get(die, [])
		var die_struck_results : Array = m_struck_roll_results.get(die, [])
		var die_struck_dropped_results : Array = m_struck_dropped_rolls.get(die, [])
		var die_struck_rerolled_results : Array = m_struck_rerolled_rolls.get(die, [])
		var die_properties : RollProperties = m_roll_properties.get(die, [])
		
		# If any die has a repeat roll property, split all the results
		if(die_properties.has_repeat_roll()):
			show_split_sums = true
			
		var main_results : ColoredDieResults = process_roll_pair(die, die.name(), die_roll_results, die_struck_results, sum_results, non_number_results, die_properties, true);
		if(main_results != null):
			roll_results_array.push_back(main_results)

		var dropped_results : ColoredDieResults = process_roll_pair(die, die.name() + ' dropped', die_dropped_results, die_struck_dropped_results, sum_results, non_number_results, die_properties, false);
		if(dropped_results != null):
			roll_results_array.push_back(dropped_results)

		var rerolled_results : ColoredDieResults = process_roll_pair(die, die.name() + ' re-rolled', die_rerolled_results, die_struck_rerolled_results, sum_results, non_number_results, die_properties, false);
		if(rerolled_results != null):
			roll_results_array.push_back(rerolled_results)

	# Only show expected result when asked for and when we have some some to report.
	if(SettingsManager.get_show_expected_result_enabled() and sum_results.size() != 0):
		var roll_average_string : String = StringHelper.decimal_to_string(roll.average(),2)
		var average_text : String = str('Expected Result - [', roll_average_string, ']')
		
		# This isn't the best way to do this, but its good enough.
		var expected_color_results : ColoredDieResults = ColoredDieResults.new().configure(average_text,"", [], [])
		roll_results_array.push_back(expected_color_results)
		
	var sum_append_text : String = '';
	
	var sum_total : int = sum_results.reduce(simple_summer,0)
	var combined_results : Array[DieResult] = []

	# Sometimes things get wonky.
	var roll_min : int = roll.minimum();
	var roll_max : int = roll.maximum();
	if(roll_min > roll_max):
		var temp : int = roll_min
		roll_min = roll_max
		roll_max = temp
	
	if(sum_results.size() != 0):
		if(show_split_sums):
			for die_sum : int in sum_results: 
				var individual_result : DieResult = DieResult.new().configure(DieResult.DieResultType.INTEGER, die_sum, roll_min, roll_max)
				combined_results.push_back(individual_result);
			sum_append_text = str(', [', sum_total, ']')
		else:
			var combined_result : DieResult = DieResult.new().configure(DieResult.DieResultType.INTEGER, sum_total, roll_min, roll_max)
			combined_results.push_back(combined_result);
			
	for non_number_result : Variant in non_number_results:
		combined_results.push_back(non_number_result)
		
	var return_color_results : ColoredDieResults = ColoredDieResults.new().configure("",sum_append_text, combined_results, [])
	
	roll_sum = return_color_results

# Lambda method for turning the roll numbers into a displayable string.
func process_roll_pair(die: AbstractDie, die_display_name: String, main_list: Array, strike_list: Array, sum_array: Array, non_number_array: Array, properties : RollProperties, show_prop_info : bool) -> ColoredDieResults:
	var main_list_check : bool = main_list != null and main_list.size() != 0
	var strike_list_check : bool = strike_list != null and strike_list.size() != 0
	var property_check : bool = show_prop_info and properties.has_modifier()
	if(main_list_check or strike_list_check || property_check):
		var prepend_string : String = die_display_name
		var append_string : String = ''
		
		if(die.is_numbered()):
			var sub_total : int = 0
			if(show_prop_info):
				sub_total = properties.get_modifier()
				if(sub_total != 0):
					append_string += ' (' + StringHelper.get_modifier_string(sub_total,true) + ')'
				if(properties.has_count_above() or properties.has_count_below()):
					for die_result : DieResult in main_list:
						if(properties.has_count_above() and properties.has_count_below()):
							if(die_result.value() >= properties.get_count_above() or die_result.value() <= properties.get_count_below()):
								sub_total += 1
						elif(properties.has_count_above()):
							if(die_result.value() >= properties.get_count_above()):
								sub_total += 1
						else:
							if(die_result.value() <= properties.get_count_below()):
								sub_total += 1
				else:
					sub_total += main_list.reduce(die_summer,0)
				if(properties.is_double()):
					append_string += ' (x2)'
					sub_total *= 2
				if(properties.is_halve()):
					append_string += ' (/2)'
					sub_total /= 2
				sub_total = floor(sub_total)
				sum_array.push_back(sub_total)
				
			prepend_string += str(' [', sub_total, ']: ')
		else:
			for value : Variant in main_list:
				non_number_array.push_back(value)
			prepend_string += ': '
			
		var die_minimum : int = die.minimum()
		var die_maximum : int = die.maximum()
		
		if(properties.get_num_dice() < 0):
			die_minimum = -die_minimum
			die_maximum = -die_maximum
		
		return ColoredDieResults.new().configure(prepend_string, append_string, main_list, strike_list)
	return null

func get_merged_keys() -> Array:
	var returnKeys : Dictionary = {}
	returnKeys.merge(m_roll_results)
	returnKeys.merge(m_dropped_rolls)
	returnKeys.merge(m_rerolled_rolls)
	returnKeys.merge(m_struck_roll_results)
	returnKeys.merge(m_struck_dropped_rolls)
	returnKeys.merge(m_struck_rerolled_rolls)
	returnKeys.merge(m_roll_properties)
	return returnKeys.keys()

func sort_all_descending() -> void:
	sort_map_lists_decending(m_roll_results)
	sort_map_lists_decending(m_dropped_rolls)
	sort_map_lists_decending(m_rerolled_rolls)
	sort_map_lists_decending(m_struck_roll_results)
	sort_map_lists_decending(m_struck_dropped_rolls)
	sort_map_lists_decending(m_struck_rerolled_rolls)

func sort_all_ascending() -> void:
	sort_map_lists_ascending(m_roll_results)
	sort_map_lists_ascending(m_dropped_rolls)
	sort_map_lists_ascending(m_rerolled_rolls)
	sort_map_lists_ascending(m_struck_roll_results)
	sort_map_lists_ascending(m_struck_dropped_rolls)
	sort_map_lists_ascending(m_struck_rerolled_rolls)

func sort_map_lists_ascending(roll_map : Dictionary) -> void:
	for roll_list : Variant in roll_map.values():
		roll_list.sort_custom(func(a : Variant, b : Variant) -> bool: return a.value() < b.value())

func sort_map_lists_decending(roll_map : Dictionary) -> void:
	for roll_list : Variant in roll_map.values():
		roll_list.sort_custom(func(a : Variant, b : Variant) -> bool: return a.value() > b.value())
