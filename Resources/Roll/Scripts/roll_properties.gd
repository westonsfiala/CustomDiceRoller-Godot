extends Resource
class_name RollProperties

const UNKNOWN_NUMBER_X : StringName = "X"
const CLASS_NAME: StringName = "RollProperties"

const NUM_DICE_IDENTIFIER : StringName = "NUM_DICE"
const NUM_DICE_TITLE_PREFIX : StringName = "Num Dice = "
const NUM_DICE_TITLE_POSTFIX : StringName = "d"
const NUM_DICE_TITLE : StringName = NUM_DICE_TITLE_PREFIX + UNKNOWN_NUMBER_X + NUM_DICE_TITLE_POSTFIX
const NUM_DICE_DISPLAY_TITLE : StringName = "Num Dice"
const NUM_DICE_DEFAULT : int = 1
func get_num_dice_string() -> String:
	return str(get_property(NUM_DICE_IDENTIFIER), NUM_DICE_TITLE_POSTFIX)
func get_num_dice_long_string() -> String:
	return str(NUM_DICE_TITLE_PREFIX, get_property(NUM_DICE_IDENTIFIER))
func has_num_dice() -> bool:
	return has_property(NUM_DICE_IDENTIFIER)
func set_num_dice(num_dice : int) -> void:
	if(num_dice == 0):
		num_dice = 1
	add_property(NUM_DICE_IDENTIFIER, num_dice)
func get_num_dice() -> int:
	return get_property(NUM_DICE_IDENTIFIER)

const DICE_MODIFIER_IDENTIFIER : StringName = "DICE_MODIFIER"
const DICE_MODIFIER_TITLE_PREFIX : StringName = "Modifier = "
const DICE_MODIFIER_TITLE_POSTFIX : StringName = ""
const DICE_MODIFIER_TITLE : StringName = DICE_MODIFIER_TITLE_PREFIX + UNKNOWN_NUMBER_X + DICE_MODIFIER_TITLE_POSTFIX
const DICE_MODIFIER_DISPLAY_TITLE : StringName = "Modifier"
const DICE_MODIFIER_DEFAULT : int = 0
func get_modifier_string() -> String:
	return str(DICE_MODIFIER_TITLE_PREFIX, get_modifier())
func has_modifier() -> bool:
	return has_property(DICE_MODIFIER_IDENTIFIER)
func set_modifier(modifier : int) -> void:
	add_property(DICE_MODIFIER_IDENTIFIER, modifier)
func get_modifier() -> int:
	return get_property(DICE_MODIFIER_IDENTIFIER)

const REPEAT_ROLL_IDENTIFIER : StringName = "REPEAT_ROLL"
const REPEAT_ROLL_TITLE_PREFIX : StringName = "Repeat |"
const REPEAT_ROLL_TITLE_POSTFIX : StringName = "| Times"
const REPEAT_ROLL_TITLE : StringName = REPEAT_ROLL_TITLE_PREFIX + UNKNOWN_NUMBER_X + REPEAT_ROLL_TITLE_POSTFIX
const REPEAT_ROLL_DISPLAY_TITLE : StringName = "Repeat Roll"
const REPEAT_ROLL_DEFAULT : int = 1
func get_repeat_roll_string() -> String:
	return str(REPEAT_ROLL_TITLE_PREFIX, get_property(REPEAT_ROLL_IDENTIFIER), REPEAT_ROLL_TITLE_POSTFIX)
func has_repeat_roll() -> bool:
	return has_property(REPEAT_ROLL_IDENTIFIER)
func set_repeat_roll(repeat : int) -> void:
	add_property(REPEAT_ROLL_IDENTIFIER, repeat)
func get_repeat_roll() -> int:
	return get_property(REPEAT_ROLL_IDENTIFIER)

enum AdvantageDisadvantageState {DISADVANTAGE, NORMAL, ADVANTAGE}
const ADVANTAGE_IDENTIFIER : StringName = "ADVANTAGE"
const DISADVANTAGE_IDENTIFIER : StringName = "DISADVANTAGE"
const ADVANTAGE_DISADVANTAGE_IDENTIFIER : StringName = "ADVANTAGE_DISADVANTAGE"
const ADVANTAGE_TITLE : StringName = "Advantage"
const DISADVANTAGE_TITLE : StringName = "Disadvantage"
const ADVANTAGE_DISADVANTAGE_DEFAULT : AdvantageDisadvantageState = AdvantageDisadvantageState.NORMAL
func get_advantage_disadvantage_string() -> String:
	if(is_advantage()):
		return ADVANTAGE_TITLE
	elif(is_disadvantage()):
		return DISADVANTAGE_TITLE
	return ''
func has_advantage_disadvantage() -> bool:
	return has_property(ADVANTAGE_DISADVANTAGE_IDENTIFIER)
func set_advantage_disadvantage(advantage_disadvantage_state: AdvantageDisadvantageState):
	add_property(ADVANTAGE_DISADVANTAGE_IDENTIFIER, advantage_disadvantage_state)
func toggle_advantage() -> void:
	if(is_advantage()):
		add_property(ADVANTAGE_DISADVANTAGE_IDENTIFIER, AdvantageDisadvantageState.NORMAL)
	else:
		add_property(ADVANTAGE_DISADVANTAGE_IDENTIFIER, AdvantageDisadvantageState.ADVANTAGE)
func toggle_disadvantage() -> void:
	if(is_disadvantage()):
		add_property(ADVANTAGE_DISADVANTAGE_IDENTIFIER, AdvantageDisadvantageState.NORMAL)
	else:
		add_property(ADVANTAGE_DISADVANTAGE_IDENTIFIER, AdvantageDisadvantageState.DISADVANTAGE)
func is_advantage() -> bool:
	return property_equals_value(ADVANTAGE_DISADVANTAGE_IDENTIFIER, AdvantageDisadvantageState.ADVANTAGE)
func is_disadvantage() -> bool:
	return property_equals_value(ADVANTAGE_DISADVANTAGE_IDENTIFIER, AdvantageDisadvantageState.DISADVANTAGE)

enum DoubleHalveState {HALVE, NORMAL, DOUBLE}
const DOUBLE_IDENTIFIER : StringName = "DOUBLE"
const HALVE_IDENTIFIER : StringName = "HALVE"
const DOUBLE_HALVE_IDENTIFIER : StringName = "DOUBLE_HALVE"
const DOUBLE_TITLE : StringName = "Double"
const HALVE_TITLE : StringName = "Halve"
const DOUBLE_HALVE_DEFAULT : DoubleHalveState = DoubleHalveState.NORMAL
func get_double_halve_string() -> String:
	if(is_double()):
		return DOUBLE_TITLE
	elif(is_halve()):
		return HALVE_TITLE
	return ''
func has_double_halve() -> bool:
	return has_property(DOUBLE_HALVE_IDENTIFIER)
func set_double_halve(doube_halve_state: DoubleHalveState):
	add_property(DOUBLE_HALVE_IDENTIFIER, doube_halve_state)
func toggle_double() -> void:
	if(is_double()):
		add_property(DOUBLE_HALVE_IDENTIFIER, DoubleHalveState.NORMAL)
	else:
		add_property(DOUBLE_HALVE_IDENTIFIER, DoubleHalveState.DOUBLE)
func toggle_halve() -> void:
	if(is_halve()):
		add_property(DOUBLE_HALVE_IDENTIFIER, DoubleHalveState.NORMAL)
	else:
		add_property(DOUBLE_HALVE_IDENTIFIER, DoubleHalveState.HALVE)
func is_double() -> bool:
	return property_equals_value(DOUBLE_HALVE_IDENTIFIER, DoubleHalveState.DOUBLE)
func is_halve() -> bool:
	return property_equals_value(DOUBLE_HALVE_IDENTIFIER, DoubleHalveState.HALVE)

const DROP_HIGHEST_IDENTIFIER : StringName = "DROP_HIGHEST"
const DROP_HIGHEST_TITLE_PREFIX : StringName = "Drop |"
const DROP_HIGHEST_TITLE_POSTFIX : StringName = "| Highest"
const DROP_HIGHEST_TITLE : StringName = DROP_HIGHEST_TITLE_PREFIX + UNKNOWN_NUMBER_X + DROP_HIGHEST_TITLE_POSTFIX
const DROP_HIGHEST_DISPLAY_TITLE : StringName = "Drop Highest"
const DROP_HIGHEST_DEFAULT : int = 0
func get_drop_highest_string() -> String:
	return str(DROP_HIGHEST_TITLE_PREFIX, get_property(DROP_HIGHEST_IDENTIFIER), DROP_HIGHEST_TITLE_POSTFIX)
func has_drop_highest() -> bool:
	return has_property(DROP_HIGHEST_IDENTIFIER)
func set_drop_highest(drop_highest : int) -> void:
	add_property(DROP_HIGHEST_IDENTIFIER, drop_highest)
func get_drop_highest() -> int:
	return get_property(DROP_HIGHEST_IDENTIFIER)

const DROP_LOWEST_IDENTIFIER : StringName = "DROP_LOWEST"
const DROP_LOWEST_TITLE_PREFIX : StringName = "Drop |"
const DROP_LOWEST_TITLE_POSTFIX : StringName = "| Lowest"
const DROP_LOWEST_TITLE : StringName = DROP_LOWEST_TITLE_PREFIX + UNKNOWN_NUMBER_X + DROP_LOWEST_TITLE_POSTFIX
const DROP_LOWEST_DISPLAY_TITLE : StringName = "Drop Lowest"
const DROP_LOWEST_DEFAULT : int = 0
func get_drop_lowest_string() -> String:
	return str(DROP_LOWEST_TITLE_PREFIX, get_property(DROP_LOWEST_IDENTIFIER), DROP_LOWEST_TITLE_POSTFIX)
func has_drop_lowest() -> bool:
	return has_property(DROP_LOWEST_IDENTIFIER)
func set_drop_lowest(drop_lowest : int) -> void:
	add_property(DROP_LOWEST_IDENTIFIER, drop_lowest)
func get_drop_lowest() -> int:
	return get_property(DROP_LOWEST_IDENTIFIER)

const KEEP_HIGHEST_IDENTIFIER : StringName = "KEEP_HIGHEST"
const KEEP_HIGHEST_TITLE_PREFIX : StringName = "Keep |"
const KEEP_HIGHEST_TITLE_POSTFIX : StringName = "| Highest"
const KEEP_HIGHEST_TITLE : StringName = KEEP_HIGHEST_TITLE_PREFIX + UNKNOWN_NUMBER_X + KEEP_HIGHEST_TITLE_POSTFIX
const KEEP_HIGHEST_DISPLAY_TITLE : StringName = "Keep Highest"
const KEEP_HIGHEST_DEFAULT : int = 0
func get_keep_highest_string() -> String:
	return str(KEEP_HIGHEST_TITLE_PREFIX, get_property(KEEP_HIGHEST_IDENTIFIER), KEEP_HIGHEST_TITLE_POSTFIX)
func has_keep_highest() -> bool:
	return has_property(KEEP_HIGHEST_IDENTIFIER)
func set_keep_highest(keep_highest : int) -> void:
	add_property(KEEP_HIGHEST_IDENTIFIER, keep_highest)
func get_keep_highest() -> int:
	return get_property(KEEP_HIGHEST_IDENTIFIER)

const KEEP_LOWEST_IDENTIFIER : StringName = "KEEP_LOWEST"
const KEEP_LOWEST_TITLE_PREFIX : StringName = "Keep |"
const KEEP_LOWEST_TITLE_POSTFIX : StringName = "| Lowest"
const KEEP_LOWEST_TITLE : StringName = KEEP_LOWEST_TITLE_PREFIX + UNKNOWN_NUMBER_X + KEEP_LOWEST_TITLE_POSTFIX
const KEEP_LOWEST_DISPLAY_TITLE : StringName = "Keep Lowest"
const KEEP_LOWEST_DEFAULT : int = 0
func get_keep_lowest_string() -> String:
	return str(KEEP_LOWEST_TITLE_PREFIX, get_property(KEEP_LOWEST_IDENTIFIER), KEEP_LOWEST_TITLE_POSTFIX)
func has_keep_lowest() -> bool:
	return has_property(KEEP_LOWEST_IDENTIFIER)
func set_keep_lowest(keep_lowest : int) -> void:
	add_property(KEEP_LOWEST_IDENTIFIER, keep_lowest)
func get_keep_lowest() -> int:
	return get_property(KEEP_LOWEST_IDENTIFIER)

const REROLL_OVER_IDENTIFIER : StringName = "REROLL_OVER"
const REROLL_OVER_TITLE_PREFIX : StringName = "Reroll Die >= |"
const REROLL_OVER_TITLE_POSTFIX : StringName = "|"
const REROLL_OVER_TITLE : StringName = REROLL_OVER_TITLE_PREFIX + UNKNOWN_NUMBER_X + REROLL_OVER_TITLE_POSTFIX
const REROLL_OVER_DISPLAY_TITLE : StringName = "Reroll Over"
const REROLL_OVER_DEFAULT : int = 0
func get_reroll_over_string() -> String:
	return str(REROLL_OVER_TITLE_PREFIX, get_property(REROLL_OVER_IDENTIFIER), REROLL_OVER_TITLE_POSTFIX)
func has_reroll_over() -> bool:
	return has_property(REROLL_OVER_IDENTIFIER)
func set_reroll_over(reroll_over : int) -> void:
	add_property(REROLL_OVER_IDENTIFIER, reroll_over)
func get_reroll_over() -> int:
	return get_property(REROLL_OVER_IDENTIFIER)

const REROLL_UNDER_IDENTIFIER : StringName = "REROLL_UNDER"
const REROLL_UNDER_TITLE_PREFIX : StringName = "Reroll Die <= |"
const REROLL_UNDER_TITLE_POSTFIX : StringName = "|"
const REROLL_UNDER_TITLE : StringName = REROLL_UNDER_TITLE_PREFIX + UNKNOWN_NUMBER_X + REROLL_UNDER_TITLE_POSTFIX
const REROLL_UNDER_DISPLAY_TITLE : StringName = "Reroll Under"
const REROLL_UNDER_DEFAULT : int = 0
func get_reroll_under_string() -> String:
	return str(REROLL_UNDER_TITLE_PREFIX, get_property(REROLL_UNDER_IDENTIFIER), REROLL_UNDER_TITLE_POSTFIX)
func has_reroll_under() -> bool:
	return has_property(REROLL_UNDER_IDENTIFIER)
func set_reroll_under(reroll_under : int) -> void:
	add_property(REROLL_UNDER_IDENTIFIER, reroll_under)
func get_reroll_under() -> int:
	return get_property(REROLL_UNDER_IDENTIFIER)

const MAXIMUM_ROLL_VALUE_IDENTIFIER : StringName = "MAXIMUM_ROLL_VALUE"
const MAXIMUM_ROLL_VALUE_TITLE_PREFIX : StringName = "Maximum = |"
const MAXIMUM_ROLL_VALUE_TITLE_POSTFIX : StringName = "|"
const MAXIMUM_ROLL_VALUE_TITLE : StringName = MAXIMUM_ROLL_VALUE_TITLE_PREFIX + UNKNOWN_NUMBER_X + MAXIMUM_ROLL_VALUE_TITLE_POSTFIX
const MAXIMUM_ROLL_VALUE_DISPLAY_TITLE : StringName = "Maximum"
const MAXIMUM_ROLL_VALUE_DEFAULT : int = 0
func get_maximum_string() -> String:
	return str(MAXIMUM_ROLL_VALUE_TITLE_PREFIX, get_property(MAXIMUM_ROLL_VALUE_IDENTIFIER), MAXIMUM_ROLL_VALUE_TITLE_POSTFIX)
func has_maximum() -> bool:
	return has_property(MAXIMUM_ROLL_VALUE_IDENTIFIER)
func set_maximum(maximum : int) -> void:
	add_property(MAXIMUM_ROLL_VALUE_IDENTIFIER, maximum)
func get_maximum() -> int:
	return get_property(MAXIMUM_ROLL_VALUE_IDENTIFIER)

const MINIMUM_ROLL_VALUE_IDENTIFIER : StringName = "MINIMUM_ROLL_VALUE"
const MINIMUM_ROLL_VALUE_TITLE_PREFIX : StringName = "Minimum = |"
const MINIMUM_ROLL_VALUE_TITLE_POSTFIX : StringName = "|"
const MINIMUM_ROLL_VALUE_TITLE : StringName = MINIMUM_ROLL_VALUE_TITLE_PREFIX + UNKNOWN_NUMBER_X + MINIMUM_ROLL_VALUE_TITLE_POSTFIX
const MINIMUM_ROLL_VALUE_DISPLAY_TITLE : StringName = "Minimum"
const MINIMUM_ROLL_VALUE_DEFAULT : int = 0
func get_minimum_string() -> String:
	return str(MINIMUM_ROLL_VALUE_TITLE_PREFIX, get_property(MINIMUM_ROLL_VALUE_IDENTIFIER), MINIMUM_ROLL_VALUE_TITLE_POSTFIX)
func has_minimum() -> bool:
	return has_property(MINIMUM_ROLL_VALUE_IDENTIFIER)
func set_minimum(minimum : int) -> void:
	add_property(MINIMUM_ROLL_VALUE_IDENTIFIER, minimum)
func get_minimum() -> int:
	return get_property(MINIMUM_ROLL_VALUE_IDENTIFIER)

const COUNT_ABOVE_EQUAL_IDENTIFIER : StringName = "COUNT_ABOVE_EQUAL"
const COUNT_ABOVE_EQUAL_TITLE_PREFIX : StringName = "Count >= |"
const COUNT_ABOVE_EQUAL_TITLE_POSTFIX : StringName = "|"
const COUNT_ABOVE_EQUAL_TITLE : StringName = COUNT_ABOVE_EQUAL_TITLE_PREFIX + UNKNOWN_NUMBER_X + COUNT_ABOVE_EQUAL_TITLE_POSTFIX
const COUNT_ABOVE_EQUAL_DISPLAY_TITLE : StringName = "Count Above Equal"
const COUNT_ABOVE_EQUAL_DEFAULT : int = 0
func get_count_above_string() -> String:
	return str(COUNT_ABOVE_EQUAL_TITLE_PREFIX, get_property(COUNT_ABOVE_EQUAL_IDENTIFIER), COUNT_ABOVE_EQUAL_TITLE_POSTFIX)
func has_count_above() -> bool:
	return has_property(COUNT_ABOVE_EQUAL_IDENTIFIER)
func set_count_above(count_above : int) -> void:
	add_property(COUNT_ABOVE_EQUAL_IDENTIFIER, count_above)
func get_count_above() -> int:
	return get_property(COUNT_ABOVE_EQUAL_IDENTIFIER)

const COUNT_BELOW_EQUAL_IDENTIFIER : StringName = "COUNT_BELOW_EQUAL"
const COUNT_BELOW_EQUAL_TITLE_PREFIX : StringName = "Count <= |"
const COUNT_BELOW_EQUAL_TITLE_POSTFIX : StringName = "|"
const COUNT_BELOW_EQUAL_TITLE : StringName = COUNT_BELOW_EQUAL_TITLE_PREFIX + UNKNOWN_NUMBER_X + COUNT_BELOW_EQUAL_TITLE_POSTFIX
const COUNT_BELOW_EQUAL_DISPLAY_TITLE : StringName = "Count Below Equal"
const COUNT_BELOW_EQUAL_DEFAULT : int = 0
func get_count_below_string() -> String:
	return str(COUNT_BELOW_EQUAL_TITLE_PREFIX, get_property(COUNT_BELOW_EQUAL_IDENTIFIER), COUNT_BELOW_EQUAL_TITLE_POSTFIX)
func has_count_below() -> bool:
	return has_property(COUNT_BELOW_EQUAL_IDENTIFIER)
func set_count_below(count_below : int) -> void:
	add_property(COUNT_BELOW_EQUAL_IDENTIFIER, count_below)
func get_count_below() -> int:
	return get_property(COUNT_BELOW_EQUAL_IDENTIFIER)

const EXPLODE_IDENTIFIER : StringName = "EXPLODE"
const EXPLODE_TITLE : StringName = "Explode"
const EXPLODE_DEFAULT : bool = false
func get_explode_string() -> String:
	return EXPLODE_TITLE
func has_explode() -> bool:
	return has_property(EXPLODE_IDENTIFIER)
func set_explode(explode: bool) -> void:
	add_property(EXPLODE_IDENTIFIER, explode)
func toggle_explode() -> void:
	add_property(EXPLODE_IDENTIFIER, !get_explode())
func get_explode() -> bool:
	return get_property(EXPLODE_IDENTIFIER)

# Order of applying properties:
# Dice props (REROLL_UNDER -> REROLL_OVER -> MINIMUM -> MAXIMUM -> EXPLODE)
# Roll props (NUM_DICE -> DROP_LOW -> DROP_HIGH ->  KEEP_LOW -> KEEP_HIGH -> 
# -> COUNT_BELOW -> COUNT_ABOVE -> DISADVANTAGE -> ADVANTAGE -> MODIFIER -> HALVE -> DOUBLE 

const PROPERTY_DEFAULT_MAP : Dictionary = {
	NUM_DICE_IDENTIFIER : NUM_DICE_DEFAULT,
	DICE_MODIFIER_IDENTIFIER : DICE_MODIFIER_DEFAULT,
	REPEAT_ROLL_IDENTIFIER : REPEAT_ROLL_DEFAULT,
	ADVANTAGE_DISADVANTAGE_IDENTIFIER : ADVANTAGE_DISADVANTAGE_DEFAULT,
	DOUBLE_HALVE_IDENTIFIER : DOUBLE_HALVE_DEFAULT,
	DROP_HIGHEST_IDENTIFIER : DROP_HIGHEST_DEFAULT,
	DROP_LOWEST_IDENTIFIER : DROP_LOWEST_DEFAULT,
	KEEP_HIGHEST_IDENTIFIER : KEEP_HIGHEST_DEFAULT,
	KEEP_LOWEST_IDENTIFIER : KEEP_LOWEST_DEFAULT,
	REROLL_OVER_IDENTIFIER : REROLL_OVER_DEFAULT,
	REROLL_UNDER_IDENTIFIER : REROLL_UNDER_DEFAULT,
	MAXIMUM_ROLL_VALUE_IDENTIFIER : MAXIMUM_ROLL_VALUE_DEFAULT,
	MINIMUM_ROLL_VALUE_IDENTIFIER : MINIMUM_ROLL_VALUE_DEFAULT,
	COUNT_ABOVE_EQUAL_IDENTIFIER : COUNT_ABOVE_EQUAL_DEFAULT,
	COUNT_BELOW_EQUAL_IDENTIFIER : COUNT_BELOW_EQUAL_DEFAULT,
	EXPLODE_IDENTIFIER : EXPLODE_DEFAULT,
}

@export var m_property_map : Dictionary = {}

# Sets the property map to the values stored in the prop dict. 
# Enforces correct key names and value types. Ignores incorrectly names or typed key:value pairs
# Maintains existing properties, unless overwritten.
# Returns the modified self.
func configure(props : Dictionary) -> RollProperties:
	for prop in props:
		add_property(prop, props[prop])
	return self

# Generates a save dict that can be used by JSON.
func save_dict() -> Dictionary:
	var save_state: Dictionary = {}
	
	save_state['schema_version'] = '1.0.0'
	save_state['class_name'] = CLASS_NAME
	save_state['properties'] = m_property_map
	
	return save_state

# Creates a new roll properties object from the given save_state.
# If any errors occur, returns a blank roll properties.
static func load_from_save_dict(save_state: Dictionary) -> RollProperties:
	# Do some checking to make sure we have all our bits.
	if not save_state.has('schema_version'):
		print("Missing schema_version during roll_properties loader")
		return RollProperties.new()
	if not save_state.has('class_name'):
		print("Missing class_name during roll_properties loader")
		return RollProperties.new()
	if not save_state.has('properties'):
		print("Missing properties during roll_properties loader")
		return RollProperties.new()
	
	# Make sure we have the correct schema version, name, and a dictionary of stuff.
	if save_state['schema_version'] != '1.0.0':
		print("Unknown schema_version during roll_properties loader: ", save_state['schema_version'])
		return RollProperties.new()
	if save_state['class_name'] != CLASS_NAME:
		print("Unknown class_name during roll_properties loader: ", save_state['class_name'])
		return RollProperties.new()
	if not save_state['properties'] is Dictionary:
		print("properties not a dictionary during roll_properties loader")
		return RollProperties.new()
	
	# Load the propterties, set them and get out.
	var loaded_properties = RollProperties.new()
	loaded_properties.m_property_map = save_state['properties']
	return loaded_properties

# Checks if the property name exists in our map and if the value matches the type of the default of that property.
func check_key_value_correctness(prop_name: StringName, value: Variant) -> bool:
	return PROPERTY_DEFAULT_MAP.has(prop_name) and typeof(value) == typeof(PROPERTY_DEFAULT_MAP[prop_name])

# Check if all of the properties are default values.
func is_default() -> bool:
	for prop in PROPERTY_DEFAULT_MAP:
		if(not property_equals_default(prop)):
			return false
	return true
	
func get_num_non_default() -> int:
	var num_non_default = 0
	for prop in PROPERTY_DEFAULT_MAP:
		if(not property_equals_default(prop)):
			num_non_default += 1
	return num_non_default

# Adds the prop value pair. Checks key value correctness.
# If the property was added.
func add_property(prop_name: StringName, value: Variant) -> bool:
	if(check_key_value_correctness(prop_name, value)):
		m_property_map[prop_name] = value
		if(property_equals_default(prop_name)):
			m_property_map.erase(prop_name)
		return true
		
	return false
	
# Checks if the property is set.
# If the map does not have the property returns false.
func has_property(prop_name: StringName) -> bool:
	if(m_property_map.has(prop_name)):
		return true
	return false
	
# Safely gets the property. 
# Returns the property value if present in the properties.
# Returns the default value if not in properties, but key is valid.
# Returns 0 if key is invalid.
func get_property(prop_name: StringName) -> Variant:
	if(m_property_map.has(prop_name)):
		return m_property_map[prop_name]
	if(PROPERTY_DEFAULT_MAP.has(prop_name)):
		return PROPERTY_DEFAULT_MAP[prop_name]
	return 0

# Checks if the property equals the given value.
# If property does not exist, returns false.
func property_equals_value(prop_name: StringName, value : Variant) -> bool:
	if(m_property_map.has(prop_name)):
		return m_property_map[prop_name] == value
	return false
	
# Checks if the proerty equals the default value.
# A missing property counts as default.
func property_equals_default(prop_name: StringName) -> bool:
	if(m_property_map.has(prop_name)):
		return m_property_map[prop_name] == PROPERTY_DEFAULT_MAP[prop_name]
	return true
	
# Checks if the proerty does not equals the default value.
# A missing property counts as default.
func property_not_equals_default(prop_name: StringName) -> bool:
	return not property_equals_default(prop_name)
