extends Control
class_name ClickableDie

var m_die : AbstractDie = SimpleRollManager.get_default_die()

@onready var die_name : SettingsManagedRichTextLabel = $LongPressButton/VerticalContainer/DieName
@onready var die_image : TextureRect = $LongPressButton/VerticalContainer/DieImage

var tween : Tween

# Signal that is sent out when a die is pressed
signal die_pressed(die: AbstractDie)
signal die_long_pressed(die: AbstractDie)

func _ready():
	SettingsManager.dice_size_changed.connect(reconfigure)

# Initializer that takes a die and connects to the SettingsManager
func configure(die : AbstractDie):
	m_die = die
	die_name.set_text_and_resize_y(str("[center]", m_die.name(), "[/center]"))
	die_image.configure_image(m_die.texture())
	reconfigure()
	
# Reconfigures the scene according to the settings
func reconfigure() -> void:
	var dice_size = SettingsManager.get_dice_size()
	
	var size_x = max(dice_size, die_name.get_content_width())
	var size_y = dice_size + die_name.custom_minimum_size.y
	var full_button_size = Vector2(size_x, size_y)
	
	# You need to change both of these values to make the flow container work
	custom_minimum_size = full_button_size
	size = full_button_size
	
	var start_position = Vector2(randi_range(-dice_size, dice_size), randi_range(-dice_size, dice_size))
	
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
