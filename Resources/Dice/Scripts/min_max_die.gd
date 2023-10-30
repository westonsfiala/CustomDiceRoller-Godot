extends NumberDie
class_name MinMaxDie

@export var min_bound : int
@export var max_bound : int

func configure(die_name: String, bound1: int, bound2: int, die_texture: Texture2D) -> MinMaxDie:
	m_name = die_name
	min_bound = min(bound1, bound2)
	max_bound = max(bound1, bound2)
	m_info = str('Rolls a number between ', min_bound, ' and ', max_bound, '\nAverage of ', average())
	m_texture = die_texture
	return self

func roll() -> int:
	return randi_range(min_bound, max_bound)

func minimum() -> int:
	return min_bound

func maximum() -> int:
	return max_bound

func average() -> float:
	return (min_bound + max_bound)/2.0

func get_faces() -> Array:
	return range(minimum(), maximum()+1)
