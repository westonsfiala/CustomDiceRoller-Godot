extends Resource
class_name Roll

@export var m_roll_name : String = "TEMP"
@export var m_roll_category : String = "TEMP"
@export var m_die_prop_array : Array[DiePropertyPair] = []

const KEEP_KEY : StringName = "Keep"
const DROP_KEY : StringName = "Drop"
const REROLL_KEY : StringName = "Reroll"

# Generate the save state for our dice
func save_dict() -> Dictionary:
	var save_state: Dictionary = {}

	save_state['schema_version'] = "1.0.0"
	save_state['class_name'] = "Roll"
	save_state['name'] = m_roll_name
	save_state['category'] = m_roll_category
	
	var die_prop_array: Array = []
	for die_prop_pair : DiePropertyPair in m_die_prop_array:
		var new_prop_pair : Dictionary = die_prop_pair.save_dict() 
		die_prop_array.push_back(new_prop_pair)
			
	save_state['die_prop_array'] = die_prop_array

	return save_state

# Creates a Roll from the save state.
# If any errors occur, returns a null object.
static func load_from_save_dict(save_state: Dictionary) -> Roll:
	# Make sure we have all the necessary parts
	if not save_state.has('schema_version'):
		print("Missing schema_version during roll loader")
		return null
	if not save_state.has('class_name'):
		print("Missing class_name during roll loader")
		return null
	if not save_state.has('name'):
		print("Missing name during roll loader")
		return null
	if not save_state.has('category'):
		print("Missing category during roll loader")
		return null
	if not save_state.has('die_prop_array'):
		print("Missing die_prop_array during roll loader")
		return null
		
	# Make sure we have the correct schema version, class_name, and other properties.
	if save_state['schema_version'] != '1.0.0':
		print("Unknown schema_version during roll loader: ", save_state['schema_version'])
		return null
	if save_state['class_name'] != "Roll":
		print("Unknown class_name during roll loader: ", save_state['class_name'])
		return null
	if not save_state['name'] is String:
		print("name not a string during roll loader")
		return null
	if not save_state['category'] is String:
		print("category not a string during roll loader")
		return null
	if not save_state['die_prop_array'] is Array:
		print("die_prop_array not an array during roll loader")
		return null
		
	var new_roll : Roll = Roll.new()
	new_roll.m_roll_name = save_state['name']
	new_roll.m_roll_category = save_state['category']
	
	var new_die_prop_array : Array[DiePropertyPair] = DiePropertyPair.load_from_save_dict_array(save_state['die_prop_array'])
	new_roll.m_die_prop_array = new_die_prop_array
	
	return new_roll

# Sets the name and category and returns itself.
func configure(name: String, category: String) -> Roll:
	m_roll_name = name
	m_roll_category = category
	return self

func roll_name() -> String:
	return m_roll_name

func category_name() -> String:
	return m_roll_category

func get_detailed_roll_name() -> String:
	var return_string : String = ""
	
	if(m_die_prop_array.size() == 0):
		return return_string
		
	var first_die : bool = true
	
	for die_prop_pair : DiePropertyPair in m_die_prop_array:
		var die : AbstractDie = die_prop_pair.m_die
		var props : RollProperties = die_prop_pair.m_roll_properties
		
		# Don't add the "+" to the first item. Only add "+" to positive count items.
		var num_dice : int = props.get_num_dice()
		if(first_die):
			first_die = false
		elif(num_dice > 0):
			return_string += "+"
			
		if(die.name().begins_with("d")):
			return_string += str(num_dice, die.name())
		else:
			return_string += str(num_dice, 'x', die.name())
			
		if (die.is_numbered()):
			if(props.has_advantage_disadvantage()):
				var prop_string : String = props.get_advantage_disadvantage_string()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.has_drop_highest()):
				var prop_string : String = props.get_drop_highest_string()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.has_drop_lowest()):
				var prop_string : String = props.get_drop_lowest_string()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.has_keep_highest()):
				var prop_string : String = props.get_keep_highest_string()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.has_keep_lowest()):
				var prop_string : String = props.get_keep_lowest_string()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.has_reroll_over()):
				var prop_string : String = props.get_reroll_over_string()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.has_reroll_under()):
				var prop_string : String = props.get_reroll_under_string()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.has_minimum()):
				var prop_string : String = props.get_minimum_string()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.has_maximum()):
				var prop_string : String = props.get_maximum_string()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.has_count_above()):
				var prop_string : String = props.get_count_above_string()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.has_count_below()):
				var prop_string : String = props.get_count_below_string()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.has_explode()):
				var prop_string : String = props.get_explode_string()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.has_modifier()):
				var prop_value : int = props.get_modifier()
				var prop_string : String = StringHelper.get_modifier_string(prop_value, true)
				return_string += StringHelper.wrap_in_parens(prop_string)
				
			if(props.has_double_halve()):
				var prop_string : String = props.get_double_halve_string()
				return_string += StringHelper.wrap_in_parens(prop_string)
				
		if(props.has_repeat_roll()):
			var prop_string : String = props.get_repeat_roll_string()
			return_string += StringHelper.wrap_in_parens(prop_string)
	return return_string

# Checks to see if all of the dice in the roll are numbered
func is_numbers_only() -> bool:
	return m_die_prop_array.all(func(pair:DiePropertyPair) -> bool: return pair.m_die.is_numbered())
	
# Returns the index of the die in the array. Compares dice by name only. 
# If the die is not found, returns -1.
func get_die_index(die: AbstractDie) -> int:
	var index : int = 0
	for die_prop_pair : DiePropertyPair in m_die_prop_array:
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
	var new_pair : DiePropertyPair = DiePropertyPair.new().configure(die.duplicate(true), properties.duplicate(true))
	m_die_prop_array.push_back(new_pair)
	return true
	
# Removes a die from a roll along with its associated properties.
# Returns if the die has been removed.
func remove_die_from_roll(die: AbstractDie) -> bool:
	var index : int = get_die_index(die)
	if(index == -1):
		return false
	m_die_prop_array.remove_at(index)
	return true

# overrides the old_die with the new_die. If new_die already exists, fails.
# Returns if the die has been overwritten.
func override_die_in_roll(old_die: AbstractDie, new_die: AbstractDie) -> bool:
	var old_index : int = get_die_index(old_die)
	var new_index : int = get_die_index(new_die)
	if(old_index == -1 or new_index != -1):
		return false
	var overwrite_die_prop_pair : DiePropertyPair = m_die_prop_array[old_index]
	overwrite_die_prop_pair.configure(new_die.duplicate(true), overwrite_die_prop_pair.m_roll_properties)
	return true

# Get the number of dice in the roll by accumulating all of the num_dice properties
func get_total_dice_in_roll() -> int:
	return m_die_prop_array.reduce(
		func(accum : int, die_prop_pair : DiePropertyPair) -> int: 
			return accum + die_prop_pair.m_roll_properties.get_num_dice(), 
		0)

# Moves the die at the given position up in the order.
# Returns if the die moved.
func move_die_up(position: int) -> bool:
	var array_size : int = m_die_prop_array.size()
	# Can't move something up when its already at the top
	# Or if there is nothing
	# Or if there is only one thing
	# Or if its past where we can access
	if(position <= 0 or array_size == 0 or array_size == 1 or position >= array_size):
		return false
		
	var newMapStart : Array = m_die_prop_array.slice(0, position-1);
	var swappedElement : Array = m_die_prop_array.slice(position-1, position);
	var movedEntry : Array = m_die_prop_array.slice(position, position+1);
	var newMapEnd : Array = m_die_prop_array.slice(position+1, array_size);
	
	m_die_prop_array = newMapStart + movedEntry + swappedElement + newMapEnd
	return true

# Moves the die at the given position down in the order.
# Returns if the die moved.
func move_die_down(position: int) -> bool:
	var array_size : int = m_die_prop_array.size()
	# Can't move something down when its already at the top
	# Or if there is nothing
	# Or if there is only one thing
	# Or if its past where we can access
	if(position < 0 or array_size == 0 or array_size == 1 or position >= array_size - 1):
		return false
		
	var newMapStart : Array = m_die_prop_array.slice(0, position);
	var movedEntry : Array = m_die_prop_array.slice(position, position+1);
	var swappedElement : Array = m_die_prop_array.slice(position+1, position+2);
	var newMapEnd : Array = m_die_prop_array.slice(position+2, array_size);
	
	m_die_prop_array = newMapStart + movedEntry + swappedElement + newMapEnd
	return true

# Big boy method that goes through all of our dice and produces a roll result.
func roll() -> RollResults:
	var return_results : RollResults = RollResults.new()
	
	for die_prop_pair : DiePropertyPair in m_die_prop_array:
		var original_die : AbstractDie = die_prop_pair.m_die
		var properties : RollProperties = die_prop_pair.m_roll_properties
		
		var num_repeats : int = max(1, abs(properties.get_repeat_roll()))
		
		for repeat_count : int in range(num_repeats):
			var die : AbstractDie = original_die
			
			if(repeat_count != 0):
				die = original_die.duplicate(true)
				die.m_name = str(die.m_name, "_", repeat_count)
			
			return_results.m_roll_properties[die] = properties
			
			if(die.is_numbered()):
				var roll_lists : Dictionary = produce_number_roll_lists((die as NumberDie), properties)
				
				# Normal case
				if(properties.has_advantage_disadvantage() == false):
					return_results.m_roll_results[die] = roll_lists[KEEP_KEY]
					return_results.m_dropped_rolls[die] = roll_lists[DROP_KEY]
					return_results.m_rerolled_rolls[die] = roll_lists[REROLL_KEY]
					return_results.m_struck_roll_results[die] = []
					return_results.m_struck_dropped_rolls[die] = []
					return_results.m_struck_rerolled_rolls[die] = []
				# Advantage/Disadvantage cases
				else:
					var second_roll_lists : Dictionary = produce_number_roll_lists((die as NumberDie), properties);
					
					var roll_lists_keep_sum : int = roll_lists[KEEP_KEY].reduce(summer, 0)
					var second_roll_lists_keep_sum : int = second_roll_lists[KEEP_KEY].reduce(summer, 0)
					
					var high_lists : Dictionary = {}
					var low_lists : Dictionary = {}
					
					if(roll_lists_keep_sum >= second_roll_lists_keep_sum):
						high_lists = roll_lists
						low_lists = second_roll_lists
					else:
						high_lists = second_roll_lists
						low_lists = roll_lists
					
					# Advantage case
					if(properties.is_advantage()):
						return_results.m_roll_results[die] = high_lists[KEEP_KEY]
						return_results.m_dropped_rolls[die] = high_lists[DROP_KEY]
						return_results.m_rerolled_rolls[die] = high_lists[REROLL_KEY]
						return_results.m_struck_roll_results[die] = low_lists[KEEP_KEY]
						return_results.m_struck_dropped_rolls[die] = low_lists[DROP_KEY]
						return_results.m_struck_rerolled_rolls[die] = low_lists[REROLL_KEY]
					# Disadvantage case
					else:
						return_results.m_roll_results[die] = low_lists[KEEP_KEY]
						return_results.m_dropped_rolls[die] = low_lists[DROP_KEY]
						return_results.m_rerolled_rolls[die] = low_lists[REROLL_KEY]
						return_results.m_struck_roll_results[die] = high_lists[KEEP_KEY]
						return_results.m_struck_dropped_rolls[die] = high_lists[DROP_KEY]
						return_results.m_struck_rerolled_rolls[die] = high_lists[REROLL_KEY]
						
			# Non-Numbered Case
			else:
				var roll_list : Array = produce_non_number_roll_list((die as NonNumberDie), properties)
				
				return_results.m_roll_results[die] = roll_list
				return_results.m_dropped_rolls[die] = []
				return_results.m_rerolled_rolls[die] = []
				return_results.m_struck_roll_results[die] = []
				return_results.m_struck_dropped_rolls[die] = []
				return_results.m_struck_rerolled_rolls[die] = []
	
	return_results.process_roll(self)
	return return_results
	
# Tiny functions used to help the reduce method
func find_max(current: DieResult, tester: DieResult) -> DieResult:
	if current == null:
		return tester
	elif tester.value() > current.value():
		return tester
	else:
		return current
		
func find_min(current: DieResult, tester: DieResult) -> DieResult: 
	if current == null:
		return tester
	elif tester.value() < current.value():
		return tester
	else:
		return current

# Helper function for summing
static func summer(accum : int, die_results: DieResult) -> int: 
	return accum+die_results.value()
		
func sort_ascending(left: DieResult, right: DieResult) -> bool: 
	return left.value() < right.value()

# Produces a dictionary of 3 lists, a list of kept values, and a list of dropped values, and a list of rerolled values
# The keys for these lists are KEEP_KEY, DROP_KEY, and REROLL_KEY
func produce_number_roll_lists(die: NumberDie, properties: RollProperties) -> Dictionary:
	var keep_list : Array = []
	var drop_list : Array =  []
	var reroll_list : Array = []
	
	var num_dice : int = properties.get_num_dice()
	# No dice to roll, return empty lists.
	if(num_dice == 0):
		return {KEEP_KEY:keep_list, DROP_KEY:drop_list, REROLL_KEY:reroll_list}
		
	# Roll all of the dice and add them to the return list.
	var roll_num : int = 0;
	while (roll_num < abs(num_dice)):
		var die_roll : DieResult = die.roll()
		
		# If we use under rerolls, reroll under the threshold.
		if(properties.has_reroll_under()):
			var reroll_under : int = abs(properties.get_reroll_under())
			if(abs(die_roll.value()) <= reroll_under):
				reroll_list.push_back(die_roll)
				die_roll = die.roll()
			
		# If we use over rerolls, reroll over the threshold.
		if(properties.has_reroll_over()):
			var reroll_over : int = abs(properties.get_reroll_over())
			if(abs(die_roll.value()) >= reroll_over):
				reroll_list.push_back(die_roll)
				die_roll = die.roll()
			
		# If we have a minimum value, drop anything less.
		if(properties.has_minimum()):
			var minimum_die_roll_value : int = abs(properties.get_minimum())
			if(abs(die_roll.value()) < minimum_die_roll_value):
				reroll_list.push_back(die_roll);
				die_roll = die_roll.duplicate()
				die_roll.override_value(min(minimum_die_roll_value, die.maximum()))
			
		# If we have a maximum value, drop anything more.
		if(properties.has_maximum()):
			var maximum_die_roll_value : int = abs(properties.get_maximum())
			if(abs(die_roll.value()) > maximum_die_roll_value):
				reroll_list.push_back(die_roll);
				die_roll = die_roll.duplicate()
				die_roll.override_value(max(maximum_die_roll_value, die.minimum()))
		
		# If we are set to explode, have the maximum value, have a range, and can roll within that range, roll an extra die
		var exploding_die : bool = properties.get_explode()
		if(exploding_die):
			var minimum_die_roll_value : int = abs(properties.get_minimum())
			if(die_roll.value() == die.maximum() and die.minimum() != die.maximum() and minimum_die_roll_value != die.maximum()):
				roll_num -= 1
			
		if(num_dice > 0):
			keep_list.push_back(die_roll)
		else:
			die_roll.negate_value()
			keep_list.push_back(die_roll)
			
		roll_num += 1;
		
	# Drop high values
	if(properties.has_drop_highest()):
		var drop_highest : int = abs(properties.get_drop_highest())
		if(keep_list.size() <= drop_highest):
			drop_list.append_array(keep_list)
			keep_list = []
		else:
			for i : int in drop_highest:
				var ejected_value : int = keep_list.reduce(find_max)
				keep_list.erase(ejected_value)
				drop_list.push_back(ejected_value)
			
	# Drop low values
	if(properties.has_drop_lowest()):
		var drop_lowest : int = abs(properties.get_drop_lowest())
		if(keep_list.size() <= drop_lowest):
			drop_list.append_array(keep_list)
			keep_list = []
		else:
			for i : int in drop_lowest:
				var ejected_value : int = keep_list.reduce(find_min)
				keep_list.erase(ejected_value)
				drop_list.push_back(ejected_value)
			
	# Only do keep high/low when you have those properties
	if(properties.has_keep_highest() or properties.has_keep_lowest()):
		# Only keep going if we have more rolls than what we want to keep
		var keep_highest : int = abs(properties.get_keep_highest())
		var keep_lowest : int = abs(properties.get_keep_lowest())
		if(keep_list.size() > (keep_highest + keep_lowest)):
			var num_to_drop : int = keep_list.size() - (keep_highest + keep_lowest)
			var index_to_drop : int = keep_lowest
			var temp_sorted : Array = keep_list.duplicate()
			temp_sorted.sort_custom(sort_ascending)
			for drop_index : int in num_to_drop:
				var ejected_value : DieResult = temp_sorted[index_to_drop + drop_index]
				keep_list.erase(ejected_value)
				drop_list.push_back(ejected_value)
				
	return {KEEP_KEY:keep_list, DROP_KEY:drop_list, REROLL_KEY:reroll_list}

# Produces a list of rolls from a NonNumberDie. All properties but number of dice are ignored.
func produce_non_number_roll_list(die: NonNumberDie, properties: RollProperties) -> Array:
	var roll_list : Array = []

	var num_dice : int = properties.get_num_dice()
	# No dice to roll, return empty lists.
	if(num_dice == 0):
		return roll_list
		
	# Roll all of the dice and add them to the return list.
	for roll_num : int in abs(num_dice):
		var die_roll : DieResult = die.roll()
		roll_list.push_back(die_roll)
		
	return roll_list;

func average() -> float:
	var roll_average : float = 0.0
	for die_prop_pair : DiePropertyPair in m_die_prop_array:
		var die : AbstractDie = die_prop_pair.m_die
		var properties: RollProperties = die_prop_pair.m_roll_properties
		if(die_prop_pair.m_die.is_numbered()):
			var individual_average : float = die.expected_result(properties);
			
			# How many dice do we actually have.
			var abs_num_dice : int = abs(properties.get_num_dice())
			var drop_lowest : int = abs(properties.get_drop_lowest())
			var drop_highest : int = abs(properties.get_drop_highest())
			var keep_lowest : int = abs(properties.get_keep_lowest())
			var keep_highest : int = abs(properties.get_keep_highest())
			
			var num_dropped : int = drop_highest + drop_lowest
			if(abs_num_dice >= num_dropped):
				abs_num_dice -= num_dropped
			else:
				abs_num_dice = 0
			
			var move_towards_high : int = drop_lowest
			var move_towards_low : int = drop_highest
			
			var keep_num : int = keep_lowest + keep_highest
			if(keep_num != 0 and keep_num < abs_num_dice):
				if(keep_highest == 0):
					move_towards_low += abs_num_dice - keep_num
				elif(keep_lowest == 0):
					move_towards_high += abs_num_dice - keep_num
				elif(keep_highest > keep_lowest):
					move_towards_high += keep_highest - keep_lowest
				else:
					move_towards_low += keep_lowest - keep_highest
				abs_num_dice = keep_num;
				
			abs_num_dice = max(0, abs_num_dice)
			
			# Are the drop / keep dice skewing the min/max
			var move_total : int = abs(move_towards_high - move_towards_low)
			
			var upper_limit : int = die.maximum()
			var lower_limit : int = die.minimum()
			
			var has_count_above : bool = properties.has_count_above()
			var has_count_below : bool = properties.has_count_below()
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
			if(properties.is_advantage()):
				individual_average = (upper_limit + individual_average*2) / 3
				
			if(properties.is_disadvantage()):
				individual_average = (lower_limit + individual_average*2) / 3
			
			var expected_result : float = individual_average * abs_num_dice;
			
			if(properties.get_num_dice() < 0):
				expected_result = -expected_result;
				
			expected_result += properties.get_modifier()
			
			if(properties.is_double()):
				expected_result *= 2
			if(properties.is_halve()):
				expected_result /= 2
				
			roll_average += expected_result * max(1, abs(properties.get_repeat_roll()))
		# Don't do anything for the non-numbered case.
	return roll_average;

func minimum() -> int:
	var roll_min : float = 0.0
	
	for die_prop_pair : DiePropertyPair in m_die_prop_array:
		var die : AbstractDie = die_prop_pair.m_die
		var properties : RollProperties = die_prop_pair.m_roll_properties
		if(die_prop_pair.m_die.is_numbered()):
			var individual_minimum : int = die.minimum()
			var num_dice : int = abs(properties.get_num_dice())
			var drop_lowest : int = abs(properties.get_drop_lowest())
			var drop_highest : int = abs(properties.get_drop_highest())
			var keep_lowest : int = abs(properties.get_keep_lowest())
			var keep_highest : int = abs(properties.get_keep_highest())
			
			num_dice -= drop_highest + drop_lowest;
			num_dice = max(0, num_dice);
			
			var keep_num : int = keep_lowest + keep_highest
			if(keep_num != 0 and keep_num < num_dice):
				num_dice = keep_num;
				
			num_dice = max(0, num_dice)
			
			var has_count_above : bool = properties.has_count_above()
			var has_count_below : bool = properties.has_count_below()
			if(has_count_above or has_count_below):
				individual_minimum = 0
				
			individual_minimum *= num_dice;
			
			individual_minimum += properties.get_modifier()
			
			if(properties.is_double()):
				individual_minimum *= 2
			if(properties.is_halve()):
				individual_minimum /= 2
				
			if(properties.get_num_dice() < 0):
				individual_minimum = -individual_minimum;
				
			roll_min += individual_minimum;
	return int(roll_min)

func maximum() -> int:
	var roll_max : float = 0.0
	
	for die_prop_pair : DiePropertyPair in m_die_prop_array:
		var die : AbstractDie = die_prop_pair.m_die
		var properties : RollProperties = die_prop_pair.m_roll_properties
		if(die_prop_pair.m_die.is_numbered()):
			var individual_maximum : int = die.maximum()
			var num_dice : int = abs(properties.get_num_dice())
			var drop_lowest : int = abs(properties.get_drop_lowest())
			var drop_highest : int = abs(properties.get_drop_highest())
			var keep_lowest : int = abs(properties.get_keep_lowest())
			var keep_highest : int = abs(properties.get_keep_highest())
			
			num_dice -= drop_highest + drop_lowest;
			num_dice = max(0, num_dice);
			
			var keep_num : int = keep_lowest + keep_highest
			if(keep_num != 0 and keep_num < num_dice):
				num_dice = keep_num;
				
			num_dice = max(0, num_dice)
			
			var has_count_above : bool = properties.has_count_above()
			var has_count_below : bool = properties.has_count_below()
			if(has_count_above or has_count_below):
				individual_maximum = 1
				
			individual_maximum *= num_dice;
			
			individual_maximum += properties.get_modifier()
			
			if(properties.is_double()):
				individual_maximum *= 2
			if(properties.is_halve()):
				individual_maximum /= 2
				
			if(properties.get_num_dice() < 0):
				individual_maximum = -individual_maximum;
				
			roll_max += individual_maximum;
	return int(roll_max)

# Only display hex when you start with "0x" and have more characters after that.
func display_in_hex() -> bool:
	return m_roll_name.length() > (AbstractDie.DIE_DISPLAY_IN_HEX.length()) && m_roll_name.begins_with(AbstractDie.DIE_DISPLAY_IN_HEX)


