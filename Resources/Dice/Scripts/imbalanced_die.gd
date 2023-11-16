extends NumberDie
class_name ImbalancedDie

@export var m_faces : Array[int]

func configure(die_name: String, faces: Array[int], die_texture: Texture2D) -> ImbalancedDie:
	if(die_name.is_empty()):
		m_name = default_name()
	else:
		m_name = die_name
	m_faces = faces
	
	m_info = str('Rolls one of the following: ', m_faces, '\nAverage of ', average())
	m_texture = die_texture
	return self
	
func default_name() -> String:
	var placeholder_name = 'd'
	placeholder_name += m_faces.reduce(func(a,b): return str(a, b, ':'), "")
	placeholder_name.trim_suffix(':')
	return placeholder_name

func roll() -> DieResult:
	var result = m_faces.pick_random()
	return DieResult.new().configure(DieResult.DieResultType.INTEGER, result, minimum(), maximum())

func minimum() -> int:
	return m_faces.min()

func maximum() -> int:
	return m_faces.max()

func average() -> float:
	if(m_faces.size() == 0):
		return 0
	return m_faces.reduce(func(a,b): return a+b,0) / m_faces.size()

func get_faces() -> Array:
	return m_faces
