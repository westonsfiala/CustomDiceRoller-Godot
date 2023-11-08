extends Resource
class_name RollProperties

const NUM_DICE_IDENTIFIER : StringName = "NUM_DICE"
const NUM_DICE_TITLE : StringName = "Xd"
const NUM_DICE_DEFAULT : int = 1
func get_num_dice_string() -> String:
	return str(get_property(NUM_DICE_IDENTIFIER), 'd')
func get_num_dice_long_string() -> String:
	return str('Num Dice = ', get_property(NUM_DICE_IDENTIFIER))
func has_num_dice() -> bool:
	return has_property(NUM_DICE_IDENTIFIER)
func get_num_dice() -> int:
	return get_property(NUM_DICE_IDENTIFIER)

const DICE_MODIFIER_IDENTIFIER : StringName = "DICE_MODIFIER"
const DICE_MODIFIER_TITLE : StringName = "Dice Modifier"
const DICE_MODIFIER_DEFAULT : int = 0
func get_modifier_string() -> String:
	return str('Modifier = ', get_modifier())
func has_modifier() -> bool:
	return has_property(DICE_MODIFIER_IDENTIFIER)
func get_modifier() -> int:
	return get_property(DICE_MODIFIER_IDENTIFIER)

const REPEAT_ROLL_IDENTIFIER : StringName = "REPEAT_ROLL"
const REPEAT_ROLL_TITLE : StringName = "Repeat |X| Times"
const REPEAT_ROLL_DEFAULT : int = 0
func get_repeat_roll_string() -> String:
	return str('Repeat |', get_property(REPEAT_ROLL_IDENTIFIER), '| Times')
func has_repeat_roll() -> bool:
	return has_property(REPEAT_ROLL_IDENTIFIER)
func get_repeat_roll() -> int:
	return get_property(REPEAT_ROLL_IDENTIFIER)

enum AdvantageDisadvantageState {DISADVANTAGE, NORMAL, ADVANTAGE}
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
func is_advantage() -> bool:
	return property_equals_value(ADVANTAGE_DISADVANTAGE_IDENTIFIER, AdvantageDisadvantageState.ADVANTAGE)
func is_disadvantage() -> bool:
	return property_equals_value(ADVANTAGE_DISADVANTAGE_IDENTIFIER, AdvantageDisadvantageState.DISADVANTAGE)

enum DoubleHalveState {HALVE, NORMAL, DOUBLE}
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
func is_double() -> bool:
	return property_equals_value(DOUBLE_HALVE_IDENTIFIER, DoubleHalveState.DOUBLE)
func is_halve() -> bool:
	return property_equals_value(DOUBLE_HALVE_IDENTIFIER, DoubleHalveState.HALVE)

const DROP_HIGHEST_IDENTIFIER : StringName = "DROP_HIGHEST"
const DROP_HIGHEST_TITLE : StringName = "Drop |X| Highest"
const DROP_HIGHEST_DEFAULT : int = 0
func get_drop_highest_string() -> String:
	return str('Drop |', get_property(DROP_HIGHEST_IDENTIFIER), '| Highest')
func has_drop_highest() -> bool:
	return has_property(DROP_HIGHEST_IDENTIFIER)
func get_drop_highest() -> int:
	return get_property(DROP_HIGHEST_IDENTIFIER)

const DROP_LOWEST_IDENTIFIER : StringName = "DROP_LOWEST"
const DROP_LOWEST_TITLE : StringName = "Drop |X| Lowest"
const DROP_LOWEST_DEFAULT : int = 0
func get_drop_lowest_string() -> String:
	return str('Drop |', get_property(DROP_LOWEST_IDENTIFIER), '| Lowest')
func has_drop_lowest() -> bool:
	return has_property(DROP_LOWEST_IDENTIFIER)
func get_drop_lowest() -> int:
	return get_property(DROP_LOWEST_IDENTIFIER)

const KEEP_HIGHEST_IDENTIFIER : StringName = "KEEP_HIGHEST"
const KEEP_HIGHEST_TITILE : StringName = "Keep |X| Highest"
const KEEP_HIGHEST_DEFAULT : int = 0
func get_keep_highest_string() -> String:
	return str('Keep |', get_property(KEEP_HIGHEST_IDENTIFIER), '| Highest')
func has_keep_highest() -> bool:
	return has_property(KEEP_HIGHEST_IDENTIFIER)
func get_keep_highest() -> int:
	return get_property(KEEP_HIGHEST_IDENTIFIER)

const KEEP_LOWEST_IDENTIFIER : StringName = "KEEP_LOWEST"
const KEEP_LOWEST_TITLE : StringName = "Keep |X| Lowest"
const KEEP_LOWEST_DEFAULT : int = 0
func get_keep_lowest_string() -> String:
	return str('Keep |', get_property(KEEP_LOWEST_IDENTIFIER), '| Lowest')
func has_keep_lowest() -> bool:
	return has_property(KEEP_LOWEST_IDENTIFIER)
func get_keep_lowest() -> int:
	return get_property(KEEP_LOWEST_IDENTIFIER)

const REROLL_OVER_IDENTIFIER : StringName = "REROLL_OVER"
const REROLL_OVER_TITLE : StringName = "Reroll Die >= |X|"
const REROLL_OVER_DEFAULT : int = 0
func get_reroll_over_string() -> String:
	return str('Reroll Die >= |', get_property(REROLL_OVER_IDENTIFIER), '|')
func has_reroll_over() -> bool:
	return has_property(REROLL_OVER_IDENTIFIER)
func get_reroll_over() -> int:
	return get_property(REROLL_OVER_IDENTIFIER)

const REROLL_UNDER_IDENTIFIER : StringName = "REROLL_UNDER"
const REROLL_UNDER_TITLE : StringName = "Reroll Die <= |X|"
const REROLL_UNDER_DEFAULT : int = 0
func get_reroll_under_string() -> String:
	return str('Reroll Die <= |', get_property(REROLL_UNDER_IDENTIFIER), '|')
func has_reroll_under() -> bool:
	return has_property(REROLL_UNDER_IDENTIFIER)
func get_reroll_under() -> int:
	return get_property(REROLL_UNDER_IDENTIFIER)

const MAXIMUM_ROLL_VALUE_IDENTIFIER : StringName = "MAXIMUM_ROLL_VALUE"
const MAXIMUM_ROLL_VALUE_TITLE : StringName = "Maximum = |X|"
const MAXIMUM_ROLL_VALUE_DEFAULT : int = 0
func get_maximum_string() -> String:
	return str('Maximum = |', get_property(MAXIMUM_ROLL_VALUE_IDENTIFIER), '|')
func has_maximum() -> bool:
	return has_property(MAXIMUM_ROLL_VALUE_IDENTIFIER)
func get_maximum() -> int:
	return get_property(MAXIMUM_ROLL_VALUE_IDENTIFIER)

const MINIMUM_ROLL_VALUE_IDENTIFIER : StringName = "MINIMUM_ROLL_VALUE"
const MINIMUM_ROLL_VALUE_TITLE : StringName = "Minimum = |X|"
const MINIMUM_ROLL_VALUE_DEFAULT : int = 0
func get_minimum_string() -> String:
	return str('Minimum = |', get_property(MINIMUM_ROLL_VALUE_IDENTIFIER), '|')
func has_minimum() -> bool:
	return has_property(MINIMUM_ROLL_VALUE_IDENTIFIER)
func get_minimum() -> int:
	return get_property(MINIMUM_ROLL_VALUE_IDENTIFIER)

const COUNT_ABOVE_EQUAL_IDENTIFIER : StringName = "COUNT_ABOVE_EQUAL"
const COUNT_ABOVE_EQUAL_TITLE : StringName = "Count >= |X|"
const COUNT_ABOVE_EQUAL_DEFAULT : int = 0
func get_count_above_string() -> String:
	return str('Count >= |', get_property(COUNT_ABOVE_EQUAL_IDENTIFIER), '|')
func has_count_above() -> bool:
	return has_property(COUNT_ABOVE_EQUAL_IDENTIFIER)
func get_count_above() -> int:
	return get_property(COUNT_ABOVE_EQUAL_IDENTIFIER)

const COUNT_BELOW_EQUAL_IDENTIFIER : StringName = "COUNT_BELOW_EQUAL"
const COUNT_BELOW_EQUAL_TITLE : StringName = "Count <= |X|"
const COUNT_BELOW_EQUAL_DEFAULT : int = 0
func get_count_below_string() -> String:
	return str('Count <= |', get_property(COUNT_BELOW_EQUAL_IDENTIFIER), '|')
func has_count_below() -> bool:
	return has_property(COUNT_BELOW_EQUAL_IDENTIFIER)
func get_count_below() -> int:
	return get_property(COUNT_BELOW_EQUAL_IDENTIFIER)

const EXPLODE_IDENTIFIER : StringName = "EXPLODE"
const EXPLODE_TITLE : StringName = "Explode"
const EXPLODE_DEFAULT : bool = false
func get_explode_string() -> String:
	return EXPLODE_TITLE
func has_explode() -> bool:
	return has_property(EXPLODE_IDENTIFIER)
func get_explode() -> int:
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
