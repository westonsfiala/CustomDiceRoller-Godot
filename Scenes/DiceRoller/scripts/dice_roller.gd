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

@onready var instruction_label : Label = $InstructionLabel
@onready var go_to_results_button : LongPressButton = $MarginContainer/GoToResultsButton

@onready var tap_timeout_timer : Timer = $TapTimeoutTimer
@onready var hold_timeout_timer : Timer = $HoldTimeoutTimer
@onready var done_timeout_timer : Timer = $DoneTimeoutTimer

enum shake_state {SHAKE, HOLD, DONE}
var state = shake_state.SHAKE

const tap_instruction_text : String = "Tap!"
const shake_instruction_text : String = "Shake!"
const hold_instruction_text : String = "Hold Still"
const done_instruction_text : String = "Done"

const extra_bumper_space : int = 150
const bumper_thickness : int = 250
const half_bumper_thickness: int = int(bumper_thickness / 2.0)

var num_taps: int = 0
const NEEDED_TAPS: int = 3
const TAP_TIMEOUT_TIME: int = 5
const HOLD_TIMEOUT_TIME: int = 2
const DONE_TIMEOUT_TIME: float = 0.25

var stored_roll_results: RollResults = RollResults.new()
var physics_dice_array: Array[PhysicsDice] = []

signal finished_animated_roll(roll_results: RollResults)

# Set up the roller with the roll it will be animating
func configure(roll_results: RollResults):
	stored_roll_results = roll_results
	
# Called when the node enters the scene tree for the first time.
func _ready():
	# reset our state
	set_shake_state(shake_state.SHAKE)
	num_taps = 0
	physics_dice_array = []
	
	SettingsManager.reconfigure.connect(deferred_reconfigure)
	reconfigure()
	
	# If we have too many dice in the roll it isn't very fun.
	# Only allow up to half of the screen to be filled with dice.
	var screen_size: Vector2 = SettingsManager.get_window_size()
	var screen_area: float = int(screen_size.x * screen_size.y)
	var die_size: float = SettingsManager.get_dice_size()
	var die_area: float = die_size * die_size
	var max_allowed_dice_float: float = screen_area / die_area / 2
	var max_allowed_dice: int = int(max_allowed_dice_float)
	
	# Go through and calculate how many dice there should be.
	var total_dice: int = 0
	var dice_dict: Dictionary = {}
	for prop_pair in stored_roll_results.stored_roll.m_die_prop_array:
		var die = prop_pair.m_die
		var properties = prop_pair.m_roll_properties
		var num_dice = properties.get_num_dice() * properties.get_repeat_roll()
		dice_dict[die] = num_dice
		total_dice += num_dice
	
	# If we have too many dice, modify it down to the correct amount.
	if total_dice > max_allowed_dice:
		var adjust_ratio: float = float(max_allowed_dice) / total_dice
		for key in dice_dict.keys():
			dice_dict[key] = int(dice_dict[key] * adjust_ratio)
	
	# Put some number of dice into the screen
	for die in dice_dict:
		for count in dice_dict[die]:
			var physics_dice_node: PhysicsDice = preload("res://Scenes/DiceRoller/physics_dice.tscn").instantiate()
			physics_dice_node.configure(die)
			physics_dice_array.push_back(physics_dice_node)
			add_child(physics_dice_node)
			

func deferred_reconfigure():
	call_deferred("reconfigure")
	
func reconfigure():
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

# While we are waiting for the taps, keep processing.
func _process(_delta):
	match state:
		shake_state.SHAKE:
			if(num_taps >= NEEDED_TAPS):
				set_shake_state(shake_state.HOLD)
		
# Set the shake state and adjust the text in the middle of screen.
func set_shake_state(new_state: shake_state):
	# Stop any timers that are still going so we don't get a timeout signal from them.
	tap_timeout_timer.stop()
	hold_timeout_timer.stop()
	done_timeout_timer.stop()
	
	# Set the new state and start the appropriate timer.
	state = new_state
	match state:
		shake_state.SHAKE:
			instruction_label.text = tap_instruction_text
			tap_timeout_timer.start(TAP_TIMEOUT_TIME)
		shake_state.HOLD:
			instruction_label.text = hold_instruction_text
			hold_timeout_timer.start(HOLD_TIMEOUT_TIME)
			for physics_die in physics_dice_array:
				physics_die.linear_damp = 2
				physics_die.angular_damp = 2
				physics_die.gravity_scale = 0
		shake_state.DONE:
			instruction_label.text = done_instruction_text
			done_timeout_timer.start(DONE_TIMEOUT_TIME)
			for physics_die in physics_dice_array:
				physics_die.freeze = true

# Press the button, leave the scene.
func _on_go_to_results_button_pressed():
	emit_signal("finished_animated_roll", stored_roll_results)

# Count the number of taps.
func _on_background_button_pressed():
	num_taps += 1

# When tap timeout occurs, go to hold.
func _on_tap_timeout_timer_timeout():
	set_shake_state(shake_state.HOLD)

# When hold timeout occurs, go to done.
func _on_hold_timeout_timer_timeout():
	set_shake_state(shake_state.DONE)

# When done timeout occurs, emit that we are finished.
func _on_done_timeout_timer_timeout():
	emit_signal("finished_animated_roll", stored_roll_results)
