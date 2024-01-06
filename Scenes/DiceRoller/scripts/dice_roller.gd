extends Control
class_name DiceRoller

@onready var top_edge : StaticBody2D = $TopEdge
@onready var top_shape : CollisionShape2D = $TopEdge/TopShape
@onready var right_edge : StaticBody2D = $RightEdge
@onready var right_shape : CollisionShape2D = $RightEdge/RightShape
@onready var bottom_edge : StaticBody2D = $BottomEdge
@onready var bottom_shape : CollisionShape2D = $BottomEdge/BottomShape
@onready var left_edge : StaticBody2D = $LeftEdge
@onready var left_shape : CollisionShape2D = $LeftEdge/LeftShape

const extra_bumper_space : int = 150
const bumper_thickness : int = 250
const half_bumper_thickness: int = int(bumper_thickness / 2.0)

var num_dice = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size: Vector2 = SettingsManager.get_window_size()
	
	# Do some precalculations for all the known sizes
	var horizontal_bumper_width = screen_size.x + extra_bumper_space * 2
	var horizontal_bumper_height = bumper_thickness
	var vertical_bumber_width = bumper_thickness
	var vertical_bumper_height = screen_size.y + extra_bumper_space * 2
	
	var half_screen_size = screen_size / 2.0
	
	# Apply the sizes and place all the bumpers
	top_shape.shape.size = Vector2(horizontal_bumper_width, horizontal_bumper_height)
	top_edge.position = Vector2(half_screen_size.x, -half_bumper_thickness)
	
	right_shape.shape.size = Vector2(vertical_bumber_width, vertical_bumper_height)
	right_edge.position = Vector2(screen_size.x + half_bumper_thickness, half_screen_size.y)
	
	bottom_shape.shape.size = Vector2(horizontal_bumper_width, horizontal_bumper_height)
	bottom_edge.position = Vector2(half_screen_size.x, screen_size.y + half_bumper_thickness)
	
	left_shape.shape.size = Vector2(vertical_bumber_width, vertical_bumper_height)
	left_edge.position = Vector2(-half_bumper_thickness, half_screen_size.y)
	
	# Put some number of dice into the screen
	for die in num_dice:
		var physics_dice_node: PhysicsDice = preload("res://Scenes/DiceRoller/physics_dice.tscn").instantiate()
		add_child(physics_dice_node)
		
