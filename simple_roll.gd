extends Control

@onready var dice_result : Label = $Background/VerticalLayout/DiceResult
@onready var dice_grid : GridContainer = $Background/VerticalLayout/DiceGrid

var d4 : MinMaxDie = MinMaxDie.new("d4", 1, 4, preload("res://DicePNGs/white/d4.png"))
var d6 : MinMaxDie = MinMaxDie.new("d6", 1, 6, preload("res://DicePNGs/white/d6.png"))
var d8 : MinMaxDie = MinMaxDie.new("d8", 1, 8, preload("res://DicePNGs/white/d8.png"))
var d10 : MinMaxDie = MinMaxDie.new("d10", 1, 10, preload("res://DicePNGs/white/d10.png"))
var d12 : MinMaxDie = MinMaxDie.new("d12", 1, 12, preload("res://DicePNGs/white/d12.png"))
var d20 : MinMaxDie = MinMaxDie.new("d20", 1, 20, preload("res://DicePNGs/white/d20.png"))
var d100 : MinMaxDie = MinMaxDie.new("d100", 1, 100, preload("res://DicePNGs/white/d100.png"))
var dice_array : Array[AbstractDie] = [d4, d6, d8, d10, d12, d20, d100]

func _ready():
	for die in dice_array:
		var diceNode = load("res://clickable_die.tscn").instantiate()
		diceNode.init(die)
		diceNode.die_pressed.connect(roll_die)
		dice_grid.add_child(diceNode)

func roll_die(die: AbstractDie):
	var result = die.roll()
	set_dice_result(result)

func set_dice_result(result):
	dice_result.text = str(result)
