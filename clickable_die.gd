extends Control
class_name ClickableDie

var m_die : AbstractDie = Settings.get_default_die()

signal die_pressed(die: AbstractDie)

func init(die : AbstractDie):
	m_die = die
	$Button/VerticalContainer/DieName.text = m_die.name()
	$Button/VerticalContainer/DieImage.texture = m_die.texture()
	Settings.reconfigure.connect(reconfigure)
	reconfigure()
	
func reconfigure() -> void:
	$Button/VerticalContainer/DieName.label_settings = Settings.get_label_settings()
	
	var new_width = Settings.get_dice_size()
	var new_size = Vector2(new_width, new_width * 1.25)
	
	# You need to change both of these values or it just doesn't seem to work...
	custom_minimum_size = new_size
	size = new_size

func _on_button_pressed():
	print(str(m_die.name(), " pressed"))
	emit_signal("die_pressed", m_die)
