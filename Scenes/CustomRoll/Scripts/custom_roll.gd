extends Control
class_name CustomRoll

@onready var no_dice_label : Label = $NoDiceLabel
@onready var custom_roll_item_layout : VBoxContainer = $VerticalLayout/MarginContainer/ScrollContainer/CustomRollItemLayout

# Connect to the settings manager and setup the scene with all of our dice
func _ready() -> void:
	SettingsManager.window_size_changed.connect(reconfigure)
	reconfigure()

# Remove all of our currently set diced and place new ones
func reconfigure() -> void:
	custom_minimum_size.x = SettingsManager.get_window_size().x

# Roll the die that was clicked and set the results
func roll_die(die: AbstractDie) -> void:
	RollManager.simple_roll(die, SimpleRollManager.get_roll_properties())

