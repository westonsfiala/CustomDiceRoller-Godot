extends Control

@onready var dice_result : Label = $VerticalLayout/DiceResult
@onready var dice_grid : HFlowContainer = $VerticalLayout/ScrollContainer/DiceGrid

# Connect to the settings manager and setup the scene with all of our dice
func _ready():
	SettingsManager.reconfigure.connect(reconfigure)
	RollManager.new_roll_result.connect(set_dice_result)
	reconfigure()

# Remove all of our currently set diced and place new ones
func reconfigure():
	SettingsManager.remove_and_free_children(dice_grid)
	for die in SettingsManager.get_default_dice():
		var dice_node = preload("res://clickable_die.tscn").instantiate()
		dice_node.die_pressed.connect(roll_die)
		dice_grid.add_child(dice_node)
		dice_node.configure(die)

# Roll the die that was clicked and set the results
func roll_die(die: AbstractDie):
	var roll_props = RollProperties.new({
		RollProperties.NUM_DICE : 1, 
		RollProperties.DICE_MODIFIER : 0,
		})
	RollManager.simple_roll(die, roll_props)

# Displays the dice results
func set_dice_result(result):
	dice_result.text = str(result)
