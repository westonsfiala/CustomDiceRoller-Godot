extends Resource
class_name DieResult


enum DieResultType {INTEGER, DECIMAL, STRING, IMAGE, INVALID}
const TYPE_KEY : StringName = 'TYPE'
const VALUE_KEY : StringName = 'VALUE'
const MIN_KEY : StringName = 'MIN'
const MAX_KEY : StringName = 'MAX'

@export var result_dict : Dictionary

# Configures the results with the given info
func configure(die_type: DieResultType, die_value: Variant, die_minimum: Variant = '', die_maximum: Variant = '') -> DieResult:
	result_dict[TYPE_KEY] = die_type
	result_dict[VALUE_KEY] = die_value
	result_dict[MIN_KEY] = die_minimum
	result_dict[MAX_KEY] = die_maximum
	return self

# Returns the type of the the die.
# This helps consumers of this class to determine what type to cast value to.
func type() -> DieResultType:
	return result_dict[TYPE_KEY]

# Returns the value that is stored.
func value() -> Variant:
	return result_dict[VALUE_KEY]

# Negates the value stored so long as it is an Integer or a Decimal.
func negate_value() -> void:
	if(type() == DieResultType.INTEGER or type() == DieResultType.DECIMAL):
		result_dict[VALUE_KEY] = -result_dict[VALUE_KEY]

# Returns if the value is equal to the minimum.
func is_minimum() -> bool:
	return result_dict[MIN_KEY] == value()
	
# Returns if the value is equal to the maximum.
func is_maximum() -> bool:
	return result_dict[MAX_KEY] == value()
