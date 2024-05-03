extends RigidBody2D
class_name PhysicsDice

var inner_die : AbstractDie = SimpleRollManager.default_die

@onready var dice_image : TextureRect = $CollisionShape2D/DiceImage
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var press_spacer_timer : Timer = $PressSpacerTimer
@onready var edge_collision_audio_player : AudioStreamPlayer = $EdgeCollisionAudioPlayer
@onready var dice_collision_audio_player : AudioStreamPlayer = $DiceCollisionAudioPlayer

const MAX_COLLISION_VELOCITY: float = 5000

var out_of_bounds_rect : Rect2 = Rect2(Vector2.ZERO, Vector2.ZERO)

var out_of_bounds_count : int = 0

func configure(die: AbstractDie) -> void:
	inner_die = die

# Launch the dice into a random direction from a random position
func _ready() -> void:
	
	# Save the out of bounds rect for dice that escape the bumpers
	var parent : Node = get_parent()
	if parent:
		out_of_bounds_rect = Rect2(-parent.size, parent.size * 3)
	else:
		var window_size : Vector2 = SettingsManager.get_window_size()
		out_of_bounds_rect = Rect2(-window_size, window_size * 3)
	
	# Load the image for our selected die
	var die_image_path : String = DieImageManager.get_die_image(inner_die.image_id())
	dice_image.configure_image(load(die_image_path))
	
	# Do some modification to the pitch, gives us some variety
	edge_collision_audio_player.pitch_scale = randf_range(0.8, 1.2)
	dice_collision_audio_player.pitch_scale = randf_range(0.8, 1.2)
	
	# Apply the dice size and adjust the collision shape
	var dice_size : int = SettingsManager.get_dice_size()
	var half_dice_size : int = int(dice_size / 2.0)
	dice_image.size = Vector2.ONE * dice_size
	dice_image.position = -Vector2.ONE * half_dice_size
	collision_shape.shape.radius = half_dice_size * .9
	
	# Give it a random position that falls inside the parent size
	give_random_position()
	
	# Give it a random starting spin
	rotation_degrees = randi_range(-360, 360)
	
	# Launch it and rotate it
	launch_die_randomly()

# Respond to presses by launching the die around.
# Only let this happen every so often though.
func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if press_spacer_timer.is_stopped():
			launch_die_randomly()
			press_spacer_timer.start()
	
	# If we aren't inside the parent rect, put ourselves back in.
	var parent : Node = get_parent()
	if parent:
		# If the dice is really far outside where it should be, put it back and launch it around.
		if not out_of_bounds_rect.has_point(position):
			# Sometimes they get really uppity, freeze the really uppity ones.
			if out_of_bounds_count > 10:
				freeze = true
			else:
				linear_velocity = Vector2.ZERO
				angular_velocity = 0
				give_random_position()
				launch_die_randomly()
				out_of_bounds_count += 1
		
# Give it a random position that falls inside the parent size
func give_random_position() -> void:
	var window_size : Vector2 = SettingsManager.get_window_size()
	var parent_size : Vector2 = get_parent_size()
	var x_pos : int = randi_range(0, int(parent_size.x))
	var y_pos : int = randi_range(0, int(parent_size.y))
	position = Vector2(x_pos, y_pos)
	
	var window_size_scale_adjust : float = (parent_size.x * parent_size.y) / (window_size.x * window_size.y)
	collision_shape.scale = Vector2.ONE * window_size_scale_adjust

func launch_die_randomly() -> void:
	var max_window_size : Vector2 = SettingsManager.get_window_size()
	
	var x_impulse : int = 0
	if linear_velocity.x > 0:
		x_impulse = randi_range(0, int(max_window_size.x)) * 5
	else:
		x_impulse = randi_range(-int(max_window_size.x), 0) * 5
		
	var y_impulse : int = 0
	if linear_velocity.y > 0:
		y_impulse = randi_range(0, int(max_window_size.y)) * 5
	else:
		y_impulse = randi_range(-int(max_window_size.y), 0) * 5
	apply_impulse(Vector2(x_impulse, y_impulse))
	apply_torque_impulse(randi_range(-10000, 10000))
	
func get_parent_size() -> Vector2:
	var window_size : Vector2 = SettingsManager.get_window_size()
	var parent_size : Vector2 = window_size
	var parent : Node = get_parent()
	if parent:
		parent_size = parent.size
	return parent_size

# On collision, play a sound
func _on_body_entered(body : Node) -> void:
	var new_volume_db : float = linear_to_db(linear_velocity.length() / MAX_COLLISION_VELOCITY)
	# Never let the volume go above base.
	new_volume_db = min(0.0, new_volume_db)
	# Play the different sounds for each type of collision: Wall vs other dice
	if body is PhysicsDice:
		dice_collision_audio_player.volume_db = new_volume_db
		dice_collision_audio_player.play()
	else:
		edge_collision_audio_player.volume_db = new_volume_db
		edge_collision_audio_player.play()
