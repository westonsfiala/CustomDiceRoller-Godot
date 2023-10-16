extends Control

@onready var dice_result : Label = $Background/VerticalLayout/DiceResult
@onready var dice_grid : HFlowContainer = $Background/VerticalLayout/ScrollContainer/DiceGrid

func _ready():
	Settings.reconfigure.connect(reconfigure)
	reconfigure()

func reconfigure():
	reset_dice()
	for die in Settings.get_default_dice():
		var dice_node = preload("res://clickable_die.tscn").instantiate()
		dice_node.init(die)
		dice_node.die_pressed.connect(roll_die)
		dice_grid.add_child(dice_node)

func roll_die(die: AbstractDie):
	var result = die.roll()
	set_dice_result(result)

func set_dice_result(result):
	dice_result.text = str(result)
	
func reset_dice():
	for n in dice_grid.get_children():
		dice_grid.remove_child(n)
		n.queue_free()
