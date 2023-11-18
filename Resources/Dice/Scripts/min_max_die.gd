extends NumberDie
class_name MinMaxDie

@export var min_bound : int
@export var max_bound : int

func configure(die_name: String, bound1: int, bound2: int) -> MinMaxDie:
	min_bound = min(bound1, bound2)
	max_bound = max(bound1, bound2)
	if(die_name.is_empty()):
		m_name = default_name()
	else:
		m_name = die_name
	m_info = str('Rolls a number between ', min_bound, ' and ', max_bound, '\nAverage of ', average())
	return self

func default_name() -> String:
	var placeholder_name : String = 'd'
	if(minimum() == 1):
		placeholder_name += str(maximum())
	else:
		placeholder_name += str(minimum(), ":", maximum())
	return placeholder_name

# Gets the image id. 
func image_id() -> int:
	var id = DieImageManager.DIE_UNKNOWN
	
	match minimum():
		-1: 
			match maximum():
				1: id = DieImageManager.DIE_FATE
		1:
			match maximum():
				2: id = DieImageManager.DIE_2
				3: id = DieImageManager.DIE_3
				4: id = DieImageManager.DIE_4
				6: id = DieImageManager.DIE_6
				8: id = DieImageManager.DIE_8
				10: id = DieImageManager.DIE_10
				12: id = DieImageManager.DIE_12
				20: id = DieImageManager.DIE_20
				100: id = DieImageManager.DIE_100
	
	return id

func roll() -> DieResult:
	var result = randi_range(min_bound, max_bound)
	return DieResult.new().configure(DieResult.DieResultType.INTEGER, result, minimum(), maximum())

func minimum() -> int:
	return min_bound

func maximum() -> int:
	return max_bound

func average() -> float:
	return (min_bound + max_bound)/2.0

func get_faces() -> Array:
	return range(minimum(), maximum()+1)
