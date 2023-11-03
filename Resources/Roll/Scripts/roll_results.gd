extends Resource
class_name RollResults

# variables that we care about after processing a roll
@export var time_string : String = ""
@export var date_string : String = ""
@export var stored_roll : Roll = Roll.new()
@export var roll_name_text : String = ""
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

# Tiny function used to help the reduce method
func simple_summer(accum, value): return accum + value
func die_summer(accum, die_result: DieResult): return accum + die_result.value()

func process_roll(roll: Roll) -> void:
	stored_roll = roll
	date_string = Time.get_date_string_from_system()
	time_string = Time.get_time_string_from_system()
	
	roll_name_text = roll.get_detailed_roll_name()
	
	var sum_results : Array[int] = []
	var non_number_results : Array = []
	var show_split_sums = false

	# Go through all of the dice in the roll and start making the roll detail lines
	for die in get_merged_keys():
		
		# TODO: sort manager
		#if(SortTypeManager.getInstance().sortAscending()) {
		#	this.storedResults.sortAscending();
		#} else if(SortTypeManager.getInstance().sortDescending()) {
		#	this.storedResults.sortDescending();
		#}
		
		var die_roll_results = m_roll_results.get(die, []);
		var die_dropped_results = m_dropped_rolls.get(die, []);
		var die_rerolled_results = m_rerolled_rolls.get(die, []);
		var die_struck_results = m_struck_roll_results.get(die, []);
		var die_struck_dropped_results = m_struck_dropped_rolls.get(die, []);
		var die_struck_rerolled_results = m_struck_rerolled_rolls.get(die, []);
		var die_properties : RollProperties = m_roll_properties.get(die, []);
		
		# If any die has a repeat roll property, split all the results
		if(die_properties.has_repeat_roll()):
			show_split_sums = true
			
		var main_results = process_roll_pair(die, die.name(), die_roll_results, die_struck_results, sum_results, non_number_results, die_properties, true);
		if(main_results != null):
			roll_results_array.push_back(main_results)

		var dropped_results = process_roll_pair(die, die.name() + ' dropped', die_dropped_results, die_struck_dropped_results, sum_results, non_number_results, die_properties, false);
		if(dropped_results != null):
			roll_results_array.push_back(dropped_results)

		var rerolled_results = process_roll_pair(die, die.name() + ' re-rolled', die_rerolled_results, die_struck_rerolled_results, sum_results, non_number_results, die_properties, false);
		if(rerolled_results != null):
			roll_results_array.push_back(rerolled_results)

	# Only show expected result when asked for and when we have some some to report.
	# TODO: Add this back in when we have settings working
	#if(ExpectedResultManager.getInstance().getShowExpected() && sum_results.length !== 0) {
	if(sum_results.size() != 0):
		var roll_average_string = StringHelper.decimal_to_string(roll.average(),2)
		var average_text = str('Expected Result - [', roll_average_string, ']')
		
		# This isn't the best way to do this, but its good enough.
		var expected_color_results = ColoredDieResults.new()
		expected_color_results.prepend_text = average_text
		expected_color_results.id = 'expected'
		roll_results_array.push_back(expected_color_results)
		
	var sum_append_text = '';
	
	var sum_total = sum_results.reduce(simple_summer,0)
	var combined_results : Array[DieResult] = []

	# Sometimes things get wonky.
	var roll_min = roll.minimum();
	var roll_max = roll.maximum();
	if(roll_min > roll_max):
		var temp = roll_min
		roll_min = roll_max
		roll_max = temp
	
	if(sum_results.size() != 0):
		if(show_split_sums):
			for die_sum in sum_results: 
				var individual_result = DieResult.new().configure(DieResult.DieResultType.INTEGER, die_sum, roll_min, roll_max)
				combined_results.push_back(individual_result);
			sum_append_text = str(', [', sum_total, ']')
		else:
			var combined_result = DieResult.new().configure(DieResult.DieResultType.INTEGER, sum_total, roll_min, roll_max)
			combined_results.push_back(combined_result);
			
	for non_number_result in non_number_results:
		combined_results.push_back(non_number_result)
		
	var return_color_results = ColoredDieResults.new().configure("",sum_append_text, roll_min, roll_max, combined_results, [], "sum")
	
	roll_sum = return_color_results

# Lambda method for turning the roll numbers into a displayable string.
func process_roll_pair(die: AbstractDie, die_display_name: String, main_list: Array, strike_list: Array, sum_array: Array, non_number_array: Array, properties : RollProperties, show_prop_info : bool) -> ColoredDieResults:
	var main_list_check = main_list != null and main_list.size() != 0
	var strike_list_check = strike_list != null and strike_list.size() != 0
	var property_check = show_prop_info and properties.has_modifier()
	if(main_list_check or strike_list_check || property_check):
		var prepend_string = die_display_name;
		var append_string = '';
		
		if(die.is_numbered()):
			var sub_total = 0;
			if(show_prop_info):
				sub_total = properties.get_modifier()
				if(sub_total != 0):
					append_string += ' (' + StringHelper.get_modifier_string(sub_total,true) + ')';
				if(properties.has_count_above() or properties.has_count_below()):
					for item in main_list:
						if(properties.has_count_above() and properties.has_count_below()):
							if(item >= properties.get_count_above() or item <= properties.get_count_below()):
								sub_total += 1
						elif(properties.has_count_above()):
							if(item >= properties.get_count_above()):
								sub_total += 1
						else:
							if(item <= properties.get_count_below()):
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
			for value in main_list:
				non_number_array.push_back(value)
			prepend_string += ': '
			
		var die_minimum = die.minimum()
		var die_maximum = die.maximum()
		
		if(properties.get_num_dice() < 0):
			die_minimum = -die_minimum
			die_maximum = -die_maximum
		
		return ColoredDieResults.new().configure(prepend_string, append_string, die_minimum, die_maximum, main_list, strike_list, die_display_name)
	return null

func get_merged_keys() -> Array:
	var returnKeys = {}
	returnKeys.merge(m_roll_results)
	returnKeys.merge(m_dropped_rolls)
	returnKeys.merge(m_rerolled_rolls)
	returnKeys.merge(m_struck_roll_results)
	returnKeys.merge(m_struck_dropped_rolls)
	returnKeys.merge(m_struck_rerolled_rolls)
	returnKeys.merge(m_roll_properties)
	return returnKeys.keys()

func sort_all_descending():
	sort_map_lists_decending(m_roll_results)
	sort_map_lists_decending(m_dropped_rolls)
	sort_map_lists_decending(m_rerolled_rolls)
	sort_map_lists_decending(m_struck_roll_results)
	sort_map_lists_decending(m_struck_dropped_rolls)
	sort_map_lists_decending(m_struck_rerolled_rolls)

func sort_all_ascending():
	sort_map_lists_ascending(m_roll_results)
	sort_map_lists_ascending(m_dropped_rolls)
	sort_map_lists_ascending(m_rerolled_rolls)
	sort_map_lists_ascending(m_struck_roll_results)
	sort_map_lists_ascending(m_struck_dropped_rolls)
	sort_map_lists_ascending(m_struck_rerolled_rolls)

func sort_map_lists_ascending(roll_map : Dictionary):
	for roll_list in roll_map.values():
		roll_list.sort_custom(func(a,b): return a < b)

func sort_map_lists_decending(roll_map : Dictionary):
	for roll_list in roll_map.values():
		roll_list.sort_custom(func(a,b): return a > b)
