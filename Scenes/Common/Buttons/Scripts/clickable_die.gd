extends Control
class_name ClickableDie

var m_die : AbstractDie = SettingsManager.get_default_die()

@onready var die_name : Label = $Button/VerticalContainer/DieName
@onready var die_image : TextureRect = $Button/VerticalContainer/DieImage

# Signal that is sent out when a die is pressed
signal die_pressed(die: AbstractDie)

func _ready():
	SettingsManager.reconfigure.connect(deferred_reconfigure)

# Initializer that takes a die and connects to the SettingsManager
func configure(die : AbstractDie):
	m_die = die
	die_name.text = m_die.name()
	die_image.texture = m_die.texture()
	reconfigure()
	
func deferred_reconfigure():
	call_deferred("reconfigure")
	
# Reconfigures the scene according to the settings
func reconfigure() -> void:
	print("reconfiguring clickable die")
	var new_width = SettingsManager.get_dice_size()
	var new_size = Vector2(new_width, new_width * 1.25)
	
	# You need to change both of these values to make the flow container work
	custom_minimum_size = new_size
	size = new_size

# When the button is pressed, emit that we are pressing the die
func _on_button_pressed():
	print(str(m_die.name(), " pressed"))
	emit_signal("die_pressed", m_die)
