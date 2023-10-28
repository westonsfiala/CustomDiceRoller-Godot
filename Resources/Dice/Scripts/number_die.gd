extends AbstractDie
class_name NumberDie

func is_numbered() -> bool:
	return true

func is_text() -> bool:
	return false

func is_image() -> bool:
	return false

func minimum() -> int:
	assert(false, "minimum - not implemented in NumberDie")
	return -1

func maximum() -> int:
	assert(false, "maximum - not implemented in NumberDie")
	return -1

func average() -> float:
	assert(false, "average - not implemented in NumberDie")
	return -1.0
	
func get_faces() -> Array[int]:
	assert(false, "get_faces - not implemented in NumberDie")
	return []

func expected_result(properties : RollProperties) -> float:
	var expected : float = 0
	
	# Need to go from min to max+1 so that we do an inclusive range
	var faces : Array[int] = get_faces()
	for face in faces:
		var value = face
		
		# If value is above min, set to min.
		var minimum_die_roll_value = properties.get_property(RollProperties.MINIMUM_ROLL_VALUE_IDENTIFIER)
		if(properties.property_not_equals_default(RollProperties.MINIMUM_ROLL_VALUE_IDENTIFIER) and abs(value) < abs(minimum_die_roll_value)):
			value = max(min(maximum(), minimum_die_roll_value), minimum())
		
		# If value is below max, set to max.
		var maximum_die_roll_value = properties.get_property(RollProperties.MAXIMUM_ROLL_VALUE_IDENTIFIER)
		if(properties.property_not_equals_default(RollProperties.MAXIMUM_ROLL_VALUE_IDENTIFIER) and abs(value) > abs(maximum_die_roll_value)):
			value = min(max(minimum(), maximum_die_roll_value), maximum())
		
		# If value is below reroll threshold, set to average.
		var reroll_under = properties.get_property(RollProperties.REROLL_UNDER_IDENTIFIER)
		if(properties.property_not_equals_default(RollProperties.REROLL_UNDER_IDENTIFIER) and abs(value) < abs(reroll_under)):
			value = average()
		
		# If value is above reroll threshold, set to average.
		var reroll_over = properties.get_property(RollProperties.REROLL_OVER_IDENTIFIER)
		if(properties.property_not_equals_default(RollProperties.REROLL_OVER_IDENTIFIER) and abs(value) > abs(reroll_over)):
			value = average()
		
		# If we explode, the average is calculated using fun maths.
		# Value = (Sum of all faces)/(Num faces - 1). A simplification of the sum of all faces is average * num_sides.
		# More info here: http://deltasdnd.blogspot.com/2021/05/exploding-dice-statistics.html
		var explode = properties.get_property(RollProperties.EXPLODE_IDENTIFIER)
		if(explode and value == maximum()):
			var num_sides = faces.size()
			if(num_sides == 1):
				value = maximum() + average()
			else:
				value = maximum() + float(num_sides)/(num_sides-1) * average()
		
		var count_below = properties.get_property(RollProperties.COUNT_BELOW_EQUAL_IDENTIFIER)
		if(properties.property_not_equals_default(RollProperties.COUNT_BELOW_EQUAL_IDENTIFIER)):
			if(value <= count_below):
				value = 1
			else:
				value = 0
				
		var count_above = properties.get_property(RollProperties.COUNT_ABOVE_EQUAL_IDENTIFIER)
		if(properties.property_not_equals_default(RollProperties.COUNT_ABOVE_EQUAL_IDENTIFIER)):
			if(value >= count_above):
				value = 1
				if(explode and value == maximum() and average() >= count_above):
					value += 1; 
			else:
				value = 0
				
		expected += value
		
	expected /= faces.size()
	return expected;
