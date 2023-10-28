extends Resource
class_name Roll

var m_roll_name : String = "TEMP"
var m_roll_category : String = "TEMP"
var m_die_prop_array : Array[DiePropertyPair] = []

const KEEP_KEY : StringName = "Keep"
const DROP_KEY : StringName = "Drop"
const REROLL_KEY : StringName = "Reroll"

# Sets the name and category and returns itself.
func configure(roll_name: String, roll_category: String) -> Roll:
	m_roll_name = roll_name
	m_roll_category = roll_category
	return self

func roll_name() -> String:
	return m_roll_name

func category_name() -> String:
	return m_roll_category

func get_detailed_roll_name() -> String:
	var return_string = ""
	
	if(m_die_prop_array.size() == 0):
		return return_string
		
	var first_die = true
	
	for die_prop_pair in m_die_prop_array:
		var die = die_prop_pair.m_die
		var props = die_prop_pair.m_roll_properties
		
		# Don't add the "+" to the first item. Only add "+" to positive count items.
		var num_dice = props.get_property(RollProperties.NUM_DICE_IDENTIFIER)
		if(first_die):
			first_die = false
		elif(num_dice > 0):
			return_string += "+"
			
		if(die.name().begins_with("d")):
			return_string += num_dice + die.name()
		else:
			return_string += num_dice + 'x' + die.name()
		
		if(die.is_numbered()):
			if(props.property_equals_value(RollProperties.ADVANTAGE_DISADVANTAGE_IDENTIFIER, RollProperties.AdvantageDisadvantageState.ADVANTAGE)):
				var prop_string = StringHelper.get_advantage_title()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.property_equals_value(RollProperties.ADVANTAGE_DISADVANTAGE_IDENTIFIER, RollProperties.AdvantageDisadvantageState.DISADVANTAGE)):
				var prop_string = StringHelper.get_disadvantage_title()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.property_not_equals_default(RollProperties.DROP_HIGHEST_IDENTIFIER)):
				var prop_value = props.get_property(RollProperties.DROP_HIGHEST_IDENTIFIER)
				var prop_string = StringHelper.get_drop_highest_string(prop_value)
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.property_not_equals_default(RollProperties.DROP_LOWEST_IDENTIFIER)):
				var prop_value = props.get_property(RollProperties.DROP_LOWEST_IDENTIFIER)
				var prop_string = StringHelper.get_drop_lowest_string(prop_value)
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.property_not_equals_default(RollProperties.KEEP_HIGHEST_IDENTIFIER)):
				var prop_value = props.get_property(RollProperties.KEEP_HIGHEST_IDENTIFIER)
				var prop_string = StringHelper.get_keep_highest_string(prop_value)
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.property_not_equals_default(RollProperties.KEEP_LOWEST_IDENTIFIER)):
				var prop_value = props.get_property(RollProperties.KEEP_LOWEST_IDENTIFIER)
				var prop_string = StringHelper.get_keep_lowest_string(prop_value)
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.property_not_equals_default(RollProperties.REROLL_OVER_IDENTIFIER)):
				var prop_value = props.get_property(RollProperties.REROLL_OVER_IDENTIFIER)
				var prop_string = StringHelper.get_reroll_over_string(prop_value)
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.property_not_equals_default(RollProperties.REROLL_UNDER_IDENTIFIER)):
				var prop_value = props.get_property(RollProperties.REROLL_UNDER_IDENTIFIER)
				var prop_string = StringHelper.get_reroll_under_string(prop_value)
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.property_not_equals_default(RollProperties.MINIMUM_ROLL_VALUE_IDENTIFIER)):
				var prop_value = props.get_property(RollProperties.MINIMUM_ROLL_VALUE_IDENTIFIER)
				var prop_string = StringHelper.get_minimum_string(prop_value)
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.property_not_equals_default(RollProperties.MAXIMUM_ROLL_VALUE_IDENTIFIER)):
				var prop_value = props.get_property(RollProperties.MAXIMUM_ROLL_VALUE_IDENTIFIER)
				var prop_string = StringHelper.get_maximum_string(prop_value)
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.property_not_equals_default(RollProperties.COUNT_ABOVE_EQUAL_IDENTIFIER)):
				var prop_value = props.get_property(RollProperties.COUNT_ABOVE_EQUAL_IDENTIFIER)
				var prop_string = StringHelper.get_count_above_equal_string(prop_value)
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.property_not_equals_default(RollProperties.COUNT_BELOW_EQUAL_IDENTIFIER)):
				var prop_value = props.get_property(RollProperties.COUNT_BELOW_EQUAL_IDENTIFIER)
				var prop_string = StringHelper.get_count_below_equal_string(prop_value)
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.property_not_equals_default(RollProperties.EXPLODE_IDENTIFIER)):
				var prop_string = StringHelper.get_explode_title()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.property_not_equals_default(RollProperties.DICE_MODIFIER_IDENTIFIER)):
				var prop_value = props.get_property(RollProperties.DICE_MODIFIER_IDENTIFIER)
				var prop_string = StringHelper.get_modifier_String(prop_value, true)
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.property_equals_value(RollProperties.DOUBLE_HALVE_IDENTIFIER, RollProperties.DoubleHalveState.DOUBLE)):
				var prop_string = StringHelper.get_double_title()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.property_equals_value(RollProperties.DOUBLE_HALVE_IDENTIFIER, RollProperties.DoubleHalveState.HALVE)):
				var prop_string = StringHelper.get_halve_title()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
		if(props.property_not_equals_default(RollProperties.REPEAT_ROLL_IDENTIFIER)):
			var prop_value = props.get_property(RollProperties.REPEAT_ROLL_IDENTIFIER)
			var prop_string = StringHelper.get_repeat_roll_string(prop_value)
			return_string += StringHelper.wrap_in_parens(prop_string)
	return return_string

# Checks to see if all of the dice in the roll are numbered
func is_numbers_only() -> bool:
	return m_die_prop_array.all(func(pair:DiePropertyPair): return pair.m_die.is_numbered())
	
# Returns the index of the die in the array. Compares dice by name only. 
# If the die is not found, returns -1.
func get_die_index(die: AbstractDie) -> int:
	var index = 0
	for die_prop_pair in m_die_prop_array:
		index += 1
		if(die_prop_pair.m_die.m_name == die.m_name):
			return index
	return -1

# Returns if the die is in the roll.
func contains_die(die: AbstractDie) -> bool:
	return get_die_index(die) != -1
	
# Adds a die to a roll. If the die already exists, fails.
# Returns if the die has been added.
func add_die_to_roll(die: AbstractDie, properties: RollProperties) -> bool:
	if(contains_die(die)):
		return false
	var new_pair = DiePropertyPair.new().configure(die.duplicate(true), properties.duplicate(true))
	m_die_prop_array.push_back(new_pair)
	return true
	
# Removes a die from a roll along with its associated properties.
# Returns if the die has been removed.
func remove_die_from_roll(die: AbstractDie) -> bool:
	var index = get_die_index(die)
	if(index == -1):
		return false
	m_die_prop_array.remove_at(index)
	return true

# overrides the old_die with the new_die. If new_die already exists, fails.
# Returns if the die has been overwritten.
func override_die_in_roll(old_die: AbstractDie, new_die: AbstractDie) -> bool:
	var old_index = get_die_index(old_die)
	var new_index = get_die_index(new_die)
	if(old_index == -1 or new_index != -1):
		return false
	var overwrite_die_prop_pair = m_die_prop_array[old_index]
	overwrite_die_prop_pair.configure(new_die.duplicate(true), overwrite_die_prop_pair.m_roll_properties)
	return true

# Get the number of dice in the roll by accumulating all of the num_dice properties
func get_total_dice_in_roll() -> int:
	return m_die_prop_array.reduce(
		func(accum,die_prop_pair): return die_prop_pair.m_roll_properties.get_property(RollProperties.NUM_DICE_IDENTIFIER), 
		0)

# Moves the die at the given position up in the order.
# Returns if the die moved.
func move_die_up(position: int) -> bool:
	var array_size = m_die_prop_array.size()
	# Can't move something up when its already at the top
	# Or if there is nothing
	# Or if there is only one thing
	# Or if its past where we can access
	if(position <= 0 or array_size == 0 or array_size == 1 or position >= array_size):
		return false
		
	var newMapStart = m_die_prop_array.slice(0, position-1);
	var swappedElement = m_die_prop_array.slice(position-1, position);
	var movedEntry = m_die_prop_array.slice(position, position+1);
	var newMapEnd = m_die_prop_array.slice(position+1, array_size);
	
	m_die_prop_array = newMapStart + movedEntry + swappedElement + newMapEnd
	return true

# Moves the die at the given position down in the order.
# Returns if the die moved.
func move_die_down(position: int) -> bool:
	var array_size = m_die_prop_array.size()
	# Can't move something down when its already at the top
	# Or if there is nothing
	# Or if there is only one thing
	# Or if its past where we can access
	if(position < 0 or array_size == 0 or array_size == 1 or position >= array_size - 1):
		return false
		
	var newMapStart = m_die_prop_array.slice(0, position);
	var movedEntry = m_die_prop_array.slice(position, position+1);
	var swappedElement = m_die_prop_array.slice(position+1, position+2);
	var newMapEnd = m_die_prop_array.slice(position+2, array_size);
	
	m_die_prop_array = newMapStart + movedEntry + swappedElement + newMapEnd
	return true

# Big boy method that goes through all of our dice and produces a roll result.
func roll() -> RollResults:
	var return_results = RollResults.new()
	
	for die_prop_pair in m_die_prop_array:
		var original_die = die_prop_pair.m_die
		var properties = die_prop_pair.m_roll_properties
		var num_repeats = max(1, abs(properties.mRepeatRoll))
		
		for repeat_count in num_repeats:
			var die = original_die
			
			if(repeat_count != 0):
				die = original_die.duplicate(true)
				die.m_name = str(die.m_name, "_", repeat_count)
				
			var die_json = JSON.stringify(die);
			
			return_results.m_roll_properties.set(die_json, properties);
			
			if(die.is_numbered()):
				var roll_lists = produce_number_roll_lists((die as NumberDie), properties)
				var advantageState = properties.get_property(RollProperties.ADVANTAGE_DISADVANTAGE_IDENTIFIER)
				
				# Normal case
				if(advantageState == RollProperties.AdvantageDisadvantageState.NORMAL):
					return_results.m_roll_results.set(die_json, roll_lists[KEEP_KEY]);
					return_results.m_dropped_rolls.set(die_json, roll_lists[DROP_KEY]);
					return_results.m_rerolled_rolls.set(die_json, roll_lists[REROLL_KEY]);
					return_results.m_struck_roll_results.set(die_json, []);
					return_results.m_struck_dropped_rolls.set(die_json, []);
					return_results.m_struck_rerolled_rolls.set(die_json, []);
					break;
				# Advantage/Disadvantage cases
				else:
					var second_roll_lists = produce_number_roll_lists((die as NumberDie), properties);
					var summer = func blah(a,b) -> int: return a+b
					
					var roll_lists_keep_sum = roll_lists[KEEP_KEY].reduce(summer, 0)
					var second_roll_lists_keep_sum = second_roll_lists[KEEP_KEY].reduce(summer, 0)
					
					var high_lists = {}
					var low_lists = {}
					
					if(roll_lists_keep_sum >= second_roll_lists_keep_sum):
						high_lists = roll_lists
						low_lists = second_roll_lists
					else:
						high_lists = second_roll_lists
						low_lists = roll_lists
					
					# Advantage case
					if(advantageState == RollProperties.AdvantageDisadvantageState.ADVANTAGE):
						return_results.m_roll_results.set(die_json, high_lists[KEEP_KEY]);
						return_results.m_dropped_rolls.set(die_json, high_lists[DROP_KEY]);
						return_results.m_rerolled_rolls.set(die_json, high_lists[REROLL_KEY]);
						return_results.m_struck_roll_results.set(die_json, low_lists[KEEP_KEY]);
						return_results.m_struck_dropped_rolls.set(die_json, low_lists[DROP_KEY]);
						return_results.m_struck_rerolled_rolls.set(die_json, low_lists[REROLL_KEY]);
					# Disadvantage case
					else:
						return_results.m_roll_results.set(die_json, low_lists[KEEP_KEY]);
						return_results.m_dropped_rolls.set(die_json, low_lists[DROP_KEY]);
						return_results.m_rerolled_rolls.set(die_json, low_lists[REROLL_KEY]);
						return_results.m_struck_roll_results.set(die_json, high_lists[KEEP_KEY]);
						return_results.m_struck_dropped_rolls.set(die_json, high_lists[DROP_KEY]);
						return_results.m_struck_rerolled_rolls.set(die_json, high_lists[REROLL_KEY]);
						
			# Non-Numbered Case
			else:
				var roll_list = produce_non_number_roll_list((die as NonNumberDie), properties)
				
				return_results.m_roll_results.set(die_json, roll_list);
				return_results.m_dropped_rolls.set(die_json, []);
				return_results.m_rerolled_rolls.set(die_json, []);
				return_results.m_struck_roll_results.set(die_json, []);
				return_results.m_struck_dropped_rolls.set(die_json, []);
				return_results.m_struck_rerolled_rolls.set(die_json, []);
	
	return return_results

# Produces a dictionary of 3 lists, a list of kept values, and a list of dropped values, and a list of rerolled values
# The keys for these lists are KEEP_KEY, DROP_KEY, and REROLL_KEY
func produce_number_roll_lists(die: NumberDie, properties: RollProperties) -> Dictionary:
	var keep_list = []
	var drop_list =  []
	var reroll_list = []
	var return_dict = {KEEP_KEY:keep_list, DROP_KEY:drop_list, REROLL_KEY:reroll_list}
	
	var num_dice = properties.get_property(RollProperties.NUM_DICE_IDENTIFIER)
	# No dice to roll, return empty lists.
	if(properties.get_property(RollProperties.NUM_DICE_IDENTIFIER) == 0):
		return return_dict
		
	# Roll all of the dice and add them to the return list.
	var roll_num = 0;
	while (roll_num < abs(num_dice)):
		var die_roll = die.roll()
		
		# If we use under rerolls, reroll under the threshold.
		var reroll_under = abs(properties.get_property(RollProperties.REROLL_UNDER_IDENTIFIER))
		if(properties.property_not_equals_default(RollProperties.REROLL_UNDER_IDENTIFIER) && abs(die_roll) <= reroll_under):
			reroll_list.push_back(die_roll)
			die_roll = die.roll()
			
		# If we use over rerolls, reroll over the threshold.
		var reroll_over = abs(properties.get_property(RollProperties.REROLL_OVER_IDENTIFIER))
		if(properties.property_not_equals_default(RollProperties.REROLL_OVER_IDENTIFIER) && abs(die_roll) >= reroll_over):
			reroll_list.push_back(die_roll)
			die_roll = die.roll()
			
		# If we have a minimum value, drop anything less.
		var minimum_die_roll_value = abs(properties.get_property(RollProperties.MINIMUM_ROLL_VALUE_IDENTIFIER))
		if(properties.property_not_equals_default(RollProperties.MINIMUM_ROLL_VALUE_IDENTIFIER) and abs(die_roll) < minimum_die_roll_value):
			reroll_list.push_back(die_roll);
			die_roll = min(minimum_die_roll_value, die.maximum())
			
		# If we have a maximum value, drop anything more.
		var maximum_die_roll_value = abs(properties.get_property(RollProperties.MAXIMUM_ROLL_VALUE_IDENTIFIER))
		if(properties.property_not_equals_default(RollProperties.MAXIMUM_ROLL_VALUE_IDENTIFIER) and abs(die_roll) > maximum_die_roll_value):
			reroll_list.push_back(die_roll);
			die_roll = max(maximum_die_roll_value, die.min)
		
		# If we are set to explode, have the maximum value, have a range, and can roll within that range, roll an extra die
		var exploding_die = properties.get_property(RollProperties.EXPLODE_IDENTIFIER)
		if(exploding_die and die_roll == die.maximum() and die.minimum() != die.maximum() and minimum_die_roll_value != die.maximum()):
			roll_num -= 1
			
		if(num_dice > 0):
			keep_list.push_back(die_roll)
		else:
			keep_list.push_back(-die_roll)
			
		roll_num += 1;
		
	# Drop high values
	var drop_highest = abs(properties.get_property(RollProperties.DROP_HIGHEST_IDENTIFIER))
	if(keep_list.size() <= drop_highest):
		drop_list.append_array(keep_list)
		keep_list = []
	else:
		for i in drop_highest:
			var ejected_value = keep_list.max()
			keep_list.erase(ejected_value)
			drop_list.push_back(ejected_value)
			
	# Drop low values
	var drop_lowest = abs(properties.get_property(RollProperties.DROP_LOWEST_IDENTIFIER))
	if(keep_list.size() <= drop_lowest):
		drop_list.append_array(keep_list)
		keep_list = []
	else:
		for i in drop_lowest:
			var ejected_value = keep_list.min()
			keep_list.erase(ejected_value)
			drop_list.push_back(ejected_value)
			
	# Only do keep high/low when you have those properties
	var keep_highest = abs(properties.get_property(RollProperties.KEEP_HIGHEST_IDENTIFIER))
	var keep_lowest = abs(properties.get_property(RollProperties.KEEP_LOWEST_IDENTIFIER))
	if(properties.property_not_equals_default(RollProperties.KEEP_HIGHEST_IDENTIFIER) or properties.property_not_equals_default(RollProperties.KEEP_LOWEST_IDENTIFIER)):
		# Only keep going if we have more rolls than what we want to keep
		if(keep_list.size() > (keep_highest + keep_lowest)):
			var num_to_drop = keep_list.size() - (keep_highest + keep_lowest)
			var index_to_drop = keep_lowest
			var temp_sorted = keep_list.duplicate()
			temp_sorted.sort()
			for drop_index in num_to_drop:
				var ejected_value = temp_sorted[index_to_drop + drop_index]
				keep_list.erase(ejected_value)
				drop_list.push_back(ejected_value)
				
	return return_dict

# Produces a list of rolls from a NonNumberDie. All properties but number of dice are ignored.
func produce_non_number_roll_list(die: NonNumberDie, properties: RollProperties) -> Array:
	var roll_list = []

	var num_dice = properties.get_property(RollProperties.NUM_DICE_IDENTIFIER)
	# No dice to roll, return empty lists.
	if(num_dice == 0):
		return roll_list
		
	# Roll all of the dice and add them to the return list.
	for roll_num in abs(num_dice):
		var die_roll = die.roll()
		roll_list.push_back(die_roll)
		
	return roll_list;

func average() -> float:
	var roll_average = 0.0
	for die_prop_pair in m_die_prop_array:
		var die = die_prop_pair.m_die
		var properties = die_prop_pair.m_roll_properties
		if(die_prop_pair.m_die.is_numbered()):
			var individual_average = die.expected_result(properties);
			
			# How many dice do we actually have.
			var num_dice = abs(properties.get_property(RollProperties.NUM_DICE_IDENTIFIER))
			var drop_lowest = abs(properties.get_property(RollProperties.DROP_LOWEST_IDENTIFIER))
			var drop_highest = abs(properties.get_property(RollProperties.DROP_HIGHEST_IDENTIFIER))
			var keep_lowest = abs(properties.get_property(RollProperties.KEEP_LOWEST_IDENTIFIER))
			var keep_highest = abs(properties.get_property(RollProperties.KEEP_LOWEST_IDENTIFIER))
			
			num_dice -= properties.get_property(RollProperties.DROP_HIGHEST_IDENTIFIER) + properties.get_property(RollProperties.DROP_LOWEST_IDENTIFIER)
			
			var move_towards_high = drop_lowest
			var move_towards_low = drop_highest
			
			var keep_num = keep_lowest + keep_highest
			if(keep_num != 0 and keep_num < num_dice):
				if(keep_highest == 0):
					move_towards_low += num_dice - keep_num
				elif(keep_lowest == 0):
					move_towards_high += num_dice - keep_num
				elif(keep_highest > keep_lowest):
					move_towards_high += keep_highest - keep_lowest
				else:
					move_towards_low += keep_lowest - keep_highest
				num_dice = keep_num;
				
			num_dice = max(0, num_dice)
			
			# Are the drop / keep dice skewing the min/max
			var move_total = abs(move_towards_high - move_towards_low)
			
			var upper_limit = die.maximum()
			var lower_limit = die.minimum()
			
			var has_count_above = properties.property_not_equals_default(RollProperties.COUNT_ABOVE_EQUAL_IDENTIFIER)
			var has_count_below = properties.property_not_equals_default(RollProperties.COUNT_BELOW_EQUAL_IDENTIFIER)
			if(has_count_above or has_count_below):
				upper_limit = 1;
				lower_limit = 0;
				
			# This will asymptotically approach either max/min as you move furthur towards high/low
			# This is not the true average shift, but it is close enough for me 
			if(move_towards_high > move_towards_low):
				individual_average = (upper_limit * move_total + 2*individual_average) / (2 + move_total)
			elif(move_towards_high < move_towards_low):
				individual_average = (lower_limit * move_total + 2*individual_average) / (2 + move_total)
				
			# Same math as above, but the move_total is always 1.
			if(properties.property_equals_value(RollProperties.ADVANTAGE_DISADVANTAGE_IDENTIFIER, RollProperties.AdvantageDisadvantageState.ADVANTAGE)):
				individual_average = (upper_limit + individual_average*2) / 3
				
			if(properties.property_equals_value(RollProperties.ADVANTAGE_DISADVANTAGE_IDENTIFIER, RollProperties.AdvantageDisadvantageState.DISADVANTAGE)):
				individual_average = (lower_limit + individual_average*2) / 3
			
			var expected_result = individual_average * num_dice;
			
			if(properties.get_property(RollProperties.NUM_DICE_IDENTIFIER) < 0):
				expected_result = -expected_result;
				
			expected_result += properties.get_property(RollProperties.DICE_MODIFIER_IDENTIFIER)
			
			if(properties.property_equals_value(RollProperties.DOUBLE_HALVE_IDENTIFIER, RollProperties.DoubleHalveState.DOUBLE)):
				expected_result *= 2
			if(properties.property_equals_value(RollProperties.DOUBLE_HALVE_IDENTIFIER, RollProperties.DoubleHalveState.HALVE)):
				expected_result /= 2
				
			roll_average += expected_result * max(1, properties.get_property(RollProperties.REPEAT_ROLL_IDENTIFIER))
		# Don't do anything for the non-numbered case.
	return roll_average;

func minimum() -> int:
	var roll_min = 0.0
	
	for die_prop_pair in m_die_prop_array:
		var die = die_prop_pair.m_die
		var properties = die_prop_pair.m_roll_properties
		if(die_prop_pair.m_die.is_numbered()):
			var individual_minimum = die.minimum()
			var num_dice = abs(properties.get_property(RollProperties.NUM_DICE_IDENTIFIER))
			var drop_lowest = abs(properties.get_property(RollProperties.DROP_LOWEST_IDENTIFIER))
			var drop_highest = abs(properties.get_property(RollProperties.DROP_HIGHEST_IDENTIFIER))
			var keep_lowest = abs(properties.get_property(RollProperties.KEEP_LOWEST_IDENTIFIER))
			var keep_highest = abs(properties.get_property(RollProperties.KEEP_LOWEST_IDENTIFIER))
			
			num_dice -= drop_highest + drop_lowest;
			num_dice = max(0, num_dice);
			
			var move_towards_high = drop_lowest
			var move_towards_low = drop_highest
			
			var keep_num = keep_lowest + keep_highest
			if(keep_num != 0 and keep_num < num_dice):
				num_dice = keep_num;
				
			num_dice = max(0, num_dice)
			
			var has_count_above = properties.property_not_equals_default(RollProperties.COUNT_ABOVE_EQUAL_IDENTIFIER)
			var has_count_below = properties.property_not_equals_default(RollProperties.COUNT_BELOW_EQUAL_IDENTIFIER)
			if(has_count_above or has_count_below):
				individual_minimum = 0
				
			individual_minimum *= num_dice;
			
			individual_minimum += properties.get_property(RollProperties.DICE_MODIFIER_IDENTIFIER)
			
			if(properties.property_equals_value(RollProperties.DOUBLE_HALVE_IDENTIFIER, RollProperties.DoubleHalveState.DOUBLE)):
				individual_minimum *= 2
			if(properties.property_equals_value(RollProperties.DOUBLE_HALVE_IDENTIFIER, RollProperties.DoubleHalveState.HALVE)):
				individual_minimum /= 2
				
			if(properties.get_property(RollProperties.NUM_DICE_IDENTIFIER) < 0):
				individual_minimum = -individual_minimum;
				
			roll_min += individual_minimum;
	return roll_min

func maximum() -> int:
	var roll_max = 0.0
	
	for die_prop_pair in m_die_prop_array:
		var die = die_prop_pair.m_die
		var properties = die_prop_pair.m_roll_properties
		if(die_prop_pair.m_die.is_numbered()):
			var individual_maximum = die.maximum()
			var num_dice = abs(properties.get_property(RollProperties.NUM_DICE_IDENTIFIER))
			var drop_lowest = abs(properties.get_property(RollProperties.DROP_LOWEST_IDENTIFIER))
			var drop_highest = abs(properties.get_property(RollProperties.DROP_HIGHEST_IDENTIFIER))
			var keep_lowest = abs(properties.get_property(RollProperties.KEEP_LOWEST_IDENTIFIER))
			var keep_highest = abs(properties.get_property(RollProperties.KEEP_LOWEST_IDENTIFIER))
			
			num_dice -= drop_highest + drop_lowest;
			num_dice = max(0, num_dice);
			
			var move_towards_high = drop_lowest
			var move_towards_low = drop_highest
			
			var keep_num = keep_lowest + keep_highest
			if(keep_num != 0 and keep_num < num_dice):
				num_dice = keep_num;
				
			num_dice = max(0, num_dice)
			
			var has_count_above = properties.property_not_equals_default(RollProperties.COUNT_ABOVE_EQUAL_IDENTIFIER)
			var has_count_below = properties.property_not_equals_default(RollProperties.COUNT_BELOW_EQUAL_IDENTIFIER)
			if(has_count_above or has_count_below):
				individual_maximum = 1
				
			individual_maximum *= num_dice;
			
			individual_maximum += properties.get_property(RollProperties.DICE_MODIFIER_IDENTIFIER)
			
			if(properties.property_equals_value(RollProperties.DOUBLE_HALVE_IDENTIFIER, RollProperties.DoubleHalveState.DOUBLE)):
				individual_maximum *= 2
			if(properties.property_equals_value(RollProperties.DOUBLE_HALVE_IDENTIFIER, RollProperties.DoubleHalveState.HALVE)):
				individual_maximum /= 2
				
			if(properties.get_property(RollProperties.NUM_DICE_IDENTIFIER) < 0):
				individual_maximum = -individual_maximum;
				
			roll_max += individual_maximum;
	return roll_max
	

# Only display hex when you start with "0x" and have more characters after that.
func display_in_hex() -> bool:
	return m_roll_name.length() > (AbstractDie.DIE_DISPLAY_IN_HEX.length()) && m_roll_name.begins_with(AbstractDie.DIE_DISPLAY_IN_HEX)


