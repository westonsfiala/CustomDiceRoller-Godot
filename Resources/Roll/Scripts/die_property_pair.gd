extends Resource
class_name DiePropertyPair

var m_die : AbstractDie
var m_roll_properties : RollProperties

func configure(die: AbstractDie, roll_properties: RollProperties):
	m_die = die
	m_roll_properties = roll_properties
