extends Resource
class_name RollProperties

const NUM_DICE_IDENTIFIER : StringName = "NUM_DICE"
const NUM_DICE_DEFAULT : int = 1

const DICE_MODIFIER_IDENTIFIER : StringName = "DICE_MODIFIER"
const DICE_MODIFIER_DEFAULT : int = 0

enum AdvantageDisadvantageState {DISADVANTAGE, NORMAL, ADVANTAGE}
const ADVANTAGE_DISADVANTAGE_IDENTIFIER : StringName = "ADVANTAGE_DISADVANTAGE"
const ADVANTAGE_DISADVANTAGE_DEFAULT : AdvantageDisadvantageState = AdvantageDisadvantageState.NORMAL

enum DoubleHalveState {HALVE, NORMAL, DOUBLE}
const DOUBLE_HALVE_IDENTIFIER : StringName = "DOUBLE_HALVE"
const DOUBLE_HALVE_DEFAULT : DoubleHalveState = DoubleHalveState.NORMAL

const REPEAT_ROLL_IDENTIFIER : StringName = "REPEAT_ROLL"
const REPEAT_ROLL_DEFAULT : int = 0

const DROP_HIGH_IDENTIFIER : StringName = "DROP_HIGH"
const DROP_HIGH_DEFAULT : int = 0

const DROP_LOW_IDENTIFIER : StringName = "DROP_LOW"
const DROP_LOW_DEFAULT : int = 0

const KEEP_HIGH_IDENTIFIER : StringName = "KEEP_HIGH"
const KEEP_HIGH_DEFAULT : int = 0

const KEEP_LOW_IDENTIFIER : StringName = "KEEP_LOW"
const KEEP_LOW_DEFAULT : int = 0

const REROLL_UNDER_IDENTIFIER : StringName = "REROLL_UNDER"
const REROLL_UNDER_DEFAULT : int = 0

const REROLL_OVER_IDENTIFIER : StringName = "REROLL_OVER"
const REROLL_OVER_DEFAULT : int = 0

const MINIMUM_ROLL_VALUE_IDENTIFIER : StringName = "MINIMUM_ROLL_VALUE"
const MINIMUM_ROLL_VALUE_DEFAULT : int = 0

const COUNT_ABOVE_EQUAL_IDENTIFIER : StringName = "COUNT_ABOVE_EQUAL"
const COUNT_ABOVE_EQUAL_DEFAULT : int = 0

const EXPLODE_IDENTIFIER : StringName = "EXPLODE"
const EXPLODE_DEFAULT : bool = false

const PROPERTY_DEFAULT_MAP : Dictionary = {
	NUM_DICE_IDENTIFIER : NUM_DICE_DEFAULT,
	DICE_MODIFIER_IDENTIFIER : DICE_MODIFIER_DEFAULT,
	ADVANTAGE_DISADVANTAGE_IDENTIFIER : DICE_MODIFIER_DEFAULT,
	DOUBLE_HALVE_IDENTIFIER : DICE_MODIFIER_DEFAULT,
	REPEAT_ROLL_IDENTIFIER : DICE_MODIFIER_DEFAULT,
	DROP_HIGH_IDENTIFIER : DICE_MODIFIER_DEFAULT,
	DROP_LOW_IDENTIFIER : DICE_MODIFIER_DEFAULT,
	KEEP_HIGH_IDENTIFIER : DICE_MODIFIER_DEFAULT,
	KEEP_LOW_IDENTIFIER : DICE_MODIFIER_DEFAULT,
	REROLL_UNDER_IDENTIFIER : DICE_MODIFIER_DEFAULT,
	REROLL_OVER_IDENTIFIER : DICE_MODIFIER_DEFAULT,
	MINIMUM_ROLL_VALUE_IDENTIFIER : DICE_MODIFIER_DEFAULT,
	COUNT_ABOVE_EQUAL_IDENTIFIER : DICE_MODIFIER_DEFAULT,
	EXPLODE_IDENTIFIER : DICE_MODIFIER_DEFAULT
}

var m_property_map : Dictionary = {}

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

# Adds the prop value pair. Checks key value correctness.
# If the property was added.
func add_property(prop_name: StringName, value: Variant) -> bool:
	if(check_key_value_correctness(prop_name, value)):
		m_property_map[prop_name] = value
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













