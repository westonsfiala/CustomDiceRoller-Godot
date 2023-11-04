extends Control

@onready var dice_result : SettingsManagedRichTextLabel = $VerticalLayout/RichTextDiceResult
@onready var dice_grid : HFlowContainer = $VerticalLayout/ScrollContainer/DiceGrid
@onready var no_dice_label : Label = $NoDiceLabel
@onready var num_dice_buttons : UpDownButtons = $VerticalLayout/PropBar/UpDownButtonBar/NumDiceUpDown
@onready var modifier_buttons : UpDownButtons = $VerticalLayout/PropBar/UpDownButtonBar/ModifierUpDown

# Connect to the settings manager and setup the scene with all of our dice
func _ready():
	RollManager.new_roll_result.connect(set_dice_result)
	SettingsManager.reconfigure.connect(deferred_reconfigure)
	deferred_reconfigure()
	
func deferred_reconfigure():
	call_deferred("reconfigure")

# Remove all of our currently set diced and place new ones
func reconfigure():
	print("reconfiguring simple roll")
	custom_minimum_size.x = SettingsManager.get_window_size().x
	SettingsManager.remove_and_free_children(dice_grid)
	for die in SettingsManager.get_dice():
		var dice_node = preload("res://Scenes/Common/Buttons/clickable_die.tscn").instantiate()
		dice_grid.add_child(dice_node)
		dice_node.die_pressed.connect(roll_die)
		dice_node.configure(die)
	refresh_no_dice()

# Roll the die that was clicked and set the results
func roll_die(die: AbstractDie):
	var roll_props = RollProperties.new().configure({
		RollProperties.NUM_DICE_IDENTIFIER : num_dice_buttons.get_value(), 
		RollProperties.DICE_MODIFIER_IDENTIFIER : modifier_buttons.get_value(),
		})
	RollManager.simple_roll(die, roll_props)

# Displays the dice results
func set_dice_result(roll_result: RollResults):
	dice_result.clear()
	dice_result.push_paragraph(HORIZONTAL_ALIGNMENT_CENTER)
	dice_result.append_text(roll_result.roll_sum.formatted_text)
	dice_result.pop()
	
func refresh_no_dice():
	var dice = SettingsManager.get_dice()
	if dice.is_empty():
		no_dice_label.visible = true
	else:
		no_dice_label.visible = false
