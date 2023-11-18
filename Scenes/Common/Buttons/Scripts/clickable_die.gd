extends Control
class_name ClickableDie

var m_die : AbstractDie = SimpleRollManager.get_default_die()

@onready var die_name : Label = $LongPressButton/VerticalContainer/DieName
@onready var die_image : TextureRect = $LongPressButton/VerticalContainer/Control/DieImage

var tween : Tween

# Signal that is sent out when a die is pressed
signal die_pressed(die: AbstractDie)
signal die_long_pressed(die: AbstractDie)

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
	
	var start_position = Vector2(randi_range(-dice_size, dice_size), randi_range(-dice_size, dice_size))
	die_image.pivot_offset = Vector2.ONE * dice_size / 2
	
	if(tween):
		tween.kill()
	tween = get_tree().create_tween().set_parallel()
	tween.tween_property(die_image, 'position', Vector2.ZERO, SettingsManager.LONG_PRESS_DELAY).from(start_position)
	tween.tween_property(die_image, 'scale', Vector2.ONE, SettingsManager.LONG_PRESS_DELAY).from(Vector2.ZERO)
	tween.tween_property(die_image, 'rotation_degrees', 0, SettingsManager.LONG_PRESS_DELAY).from(-360)

func _on_long_press_button_short_pressed():
	print(str(m_die.name(), " pressed"))
	emit_signal("die_pressed", m_die)

func _on_long_press_button_long_pressed():
	emit_signal("die_long_pressed", m_die)
