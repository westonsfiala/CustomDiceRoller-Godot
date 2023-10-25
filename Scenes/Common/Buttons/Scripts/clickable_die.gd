extends Control
class_name ClickableDie

var m_die : AbstractDie = SettingsManager.get_default_die()

@onready var die_name : Label = $LongPressButton/VerticalContainer/DieName
@onready var die_image : TextureRect = $LongPressButton/VerticalContainer/DieImage

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
	var dice_size = SettingsManager.get_dice_size()
	var text_min_size = SettingsManager.get_text_size()
	
	var full_button_size = Vector2(dice_size, dice_size + text_min_size)
	
	# You need to change both of these values to make the flow container work
	custom_minimum_size = full_button_size
	size = full_button_size

func _on_long_press_button_short_pressed():
	print(str(m_die.name(), " pressed"))
	emit_signal("die_pressed", m_die)
