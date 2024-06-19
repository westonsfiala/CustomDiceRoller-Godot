extends LongPressButton
class_name DieSelectorButton

@onready var die_image : SettingsManagedDiceImage = $HBoxContainer/DiceImage
@onready var die_name : SettingsManagedRichTextLabel = $HBoxContainer/DiceName

var die : AbstractDie = SimpleRollManager.default_min_max_die

signal die_selected(die : AbstractDie)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SettingsManager.button_size_changed.connect(reconfigure)
	reconfigure()

# Reconfigures the scene according to the settings
func reconfigure() -> void:
	var button_size : int = SettingsManager.get_button_size()
	custom_minimum_size.y = button_size
	die_image.custom_minimum_size = Vector2.ONE * button_size

func configure(new_die : AbstractDie) -> void:
	die = new_die
	die_image.configure_image(die.texture())
	die_image.reconfigure_image()
	die_name.set_text_and_resize_y_centered(die.name())

func _on_pressed() -> void:
	emit_signal("die_selected", die)
