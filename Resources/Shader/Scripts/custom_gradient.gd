extends Resource
class_name CustomGradient

# Colors in the gradient.
@export var colors : PackedColorArray = []

# How do the colors blend together or not.
enum BLEND_TYPE {CONSTANT, LINEAR}
@export var blend_type : BLEND_TYPE = BLEND_TYPE.LINEAR

# If the colors are laid out linearly, or radially
enum FILL_TYPE {LINEAR, RADIAL, SQUARE}
@export var fill_type : FILL_TYPE = FILL_TYPE.LINEAR

# The direction that the gradient goes
enum LAYOUT_DIRECTION {HORIZONTAL, VERTICAL, DIAGONAL_DOWN, DIAGONAL_UP}
@export var layout_direction : LAYOUT_DIRECTION = LAYOUT_DIRECTION.DIAGONAL_DOWN

# Number of times to repeat the gradient
@export var repeat_num : float = 1.0

# How to do the repeat
enum REPEAT_TYPE {NO_REPEAT, REPEAT, MIRROR_REPEAT}
@export var repeat_type: REPEAT_TYPE = REPEAT_TYPE.NO_REPEAT

# Generated the texture2D from all of the exports
func generate_gradient_texture_2d() -> GradientTexture2D:
	
	# Create the inner gradient for the texture.
	var inner_gradient = Gradient.new()
	
	# Make sure we have at least 1 color.
	var gradient_colors: PackedColorArray = colors
	if(gradient_colors.is_empty()):
		gradient_colors = [Color.WHITE]
	
	# Set the colors
	inner_gradient.colors = gradient_colors
	
	# Used for generating the offsets
	var divisor = 1.0
	
	# Set the interpolation.
	match blend_type:
		BLEND_TYPE.CONSTANT:
			inner_gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CONSTANT
			divisor = gradient_colors.size()
		BLEND_TYPE.LINEAR:
			inner_gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_LINEAR
			divisor = gradient_colors.size() - 1
	
	
	# Generate the offsets for the colors
	var gradient_offsets: PackedFloat32Array = []
	
	# Don't divide by 0
	if divisor == 0:
		divisor = 1.0
		
	# Example: 3 colors are in an array
	# Linear offsets = [0,.5,1]
	# Constant offsets = [0,.33, .66]
	for i in range(0, gradient_colors.size()):
		var new_offset = float(i)/divisor
		gradient_offsets.append(new_offset)
		
	inner_gradient.offsets = gradient_offsets
	
	# With the new gradient, make the texture.
	var new_texture = GradientTexture2D.new()
	new_texture.gradient = inner_gradient
	# 512 is good enough for most applications
	new_texture.width = 512
	new_texture.height = 512
	
	var fill_from : Vector2 = Vector2.ZERO
	var fill_to : Vector2 = Vector2.ONE
			
	match layout_direction:
		LAYOUT_DIRECTION.HORIZONTAL:
			fill_from = Vector2(0,.5)
			fill_to = Vector2(1,.5)
		LAYOUT_DIRECTION.VERTICAL:
			fill_from = Vector2(.5,0)
			fill_to = Vector2(.5,1)
		LAYOUT_DIRECTION.DIAGONAL_DOWN:
			fill_from = Vector2(0,0)
			fill_to = Vector2(1,1)
		LAYOUT_DIRECTION.DIAGONAL_UP:
			fill_from = Vector2(0,1)
			fill_to = Vector2(1,0)
			
	# If we are radial or square, from now must be centered.
	match fill_type:
		FILL_TYPE.LINEAR:
			new_texture.fill = GradientTexture2D.FILL_LINEAR
		FILL_TYPE.RADIAL:
			new_texture.fill = GradientTexture2D.FILL_RADIAL
			fill_from = Vector2(0.5,0.5)
		FILL_TYPE.SQUARE:
			new_texture.fill = GradientTexture2D.FILL_SQUARE
			fill_from = Vector2(0.5,0.5)
	
	# Make the direction vector to help with repeats.
	var fill_direction_vector = fill_from.direction_to(fill_to)
	
	# Sanity check for making sure we don't increase vector size.
	var repeats = repeat_num
	if(repeats < 1.0):
		repeats = 1.0
	
	# Set how we repeat and adjust the fill_to vector accordingly.
	match repeat_type:
		REPEAT_TYPE.NO_REPEAT:
			new_texture.repeat = GradientTexture2D.REPEAT_NONE
		REPEAT_TYPE.REPEAT:
			new_texture.repeat = GradientTexture2D.REPEAT
			fill_direction_vector = fill_direction_vector / repeats
		REPEAT_TYPE.MIRROR_REPEAT:
			new_texture.repeat = GradientTexture2D.REPEAT_MIRROR
			fill_direction_vector = fill_direction_vector / repeats
	
	# Set the final fill_to vector from the from vector and the possibly modified repeat vector.
	fill_to = fill_from + fill_direction_vector
	new_texture.fill_from = fill_from
	new_texture.fill_to = fill_to
	
	return new_texture
	
# Randomize the exports of the gradient.
func make_random():
	var num_colors = randi_range(2,6)
	colors = []
	for i in range(num_colors):
		var red = randf_range(0,1)
		var green = randf_range(0,1)
		var blue = randf_range(0,1)
		colors.append(Color(red, green, blue))

	# Enums are always starting from 0 so this works.
	blend_type = randi_range(0,1) as BLEND_TYPE
	fill_type = randi_range(0,2) as FILL_TYPE
	layout_direction = randi_range(0,3) as LAYOUT_DIRECTION
	repeat_num = float(randi_range(1,15))
	repeat_type = randi_range(0,2) as REPEAT_TYPE
