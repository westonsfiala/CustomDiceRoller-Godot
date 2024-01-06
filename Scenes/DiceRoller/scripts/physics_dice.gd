extends RigidBody2D
class_name PhysicsDice

var inner_die : AbstractDie = SimpleRollManager.default_die

@onready var dice_image : TextureRect = $CollisionShape2D/DiceImage
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

func configure(die: AbstractDie):
	inner_die = die

# Launch the dice into a random direction from a random position
func _ready():
	# Load the image for our selected die
	var die_image_path = DieImageManager.get_die_image(inner_die.image_id())
	dice_image.texture = load(die_image_path)
	
	# Apply the dice size and adjust the collision shape
	var dice_size : int = SettingsManager.get_dice_size()
	var half_dice_size : int = int(dice_size / 2.0)
	dice_image.size = Vector2.ONE * dice_size
	dice_image.position = -Vector2.ONE * half_dice_size
	collision_shape.shape.radius = half_dice_size * .9
	
	# Give it a random position that falls inside the window
	var max_window_size = SettingsManager.get_window_size()
	var x_pos = randi_range(0,max_window_size.x)
	var y_pos = randi_range(0,max_window_size.y)
	position = Vector2(x_pos, y_pos)
	
	# Give it a random starting spin
	rotation_degrees = randi_range(-360, 360)
	
	# Launch it and rotate it
	var x_impulse = randi_range(-max_window_size.x,max_window_size.x) * 5
	var y_impulse = randi_range(-max_window_size.y,max_window_size.y) * 5
	apply_impulse(Vector2(x_impulse, y_impulse))
	apply_torque_impulse(randi_range(-360, 360))

func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var dir = global_position.direction_to(get_global_mouse_position())
		apply_impulse(-dir * 1000)
