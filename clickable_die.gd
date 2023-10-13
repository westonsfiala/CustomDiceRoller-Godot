extends Control
class_name ClickableDie

var m_die : AbstractDie = MinMaxDie.new("TEMP",1,1, preload("res://DicePNGs/white/unknown-die.png"))

signal die_pressed(die: AbstractDie)

func init(die : AbstractDie):
	m_die = die
	$Button/VerticalContainer/Label.text = m_die.name()
	$Button/VerticalContainer/TextureRect.texture = m_die.texture()

func _on_button_pressed():
	print(str(m_die.name(), " pressed"))
	emit_signal("die_pressed", m_die)
