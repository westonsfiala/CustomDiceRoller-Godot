extends Resource
class_name DiePropertyPair

@export var m_die : AbstractDie
@export var m_roll_properties : RollProperties

func configure(die: AbstractDie, roll_properties: RollProperties) -> DiePropertyPair:
	m_die = die
	m_roll_properties = roll_properties
	return self
