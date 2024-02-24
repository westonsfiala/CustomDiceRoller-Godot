extends VBoxContainer
class_name CustomThemeListItem

# Display theme
@onready var theme_list_item : ThemeListItem = $ThemeListItem

const BLEND_TYPE_TEXT : StringName = "[center]Blend Type[/center]"
@onready var blend_rich_text : SettingsManagedRichTextLabel = $BlendTypeRichTextLabel
@onready var linear_blend_button : Button = $BlendTypeContainer/LinearBlendType
@onready var constant_blend_button : Button = $BlendTypeContainer/ConstantBlendType

const FILL_TYPE_TEXT : StringName = "[center]Fill Type[/center]"
@onready var fill_rich_text : SettingsManagedRichTextLabel = $FillTypeRichTextLabel
@onready var linear_fill_button : Button = $FillTypeContainer/LinearFillType
@onready var radial_fill_button : Button = $FillTypeContainer/RadialFillType
@onready var square_fill_button : Button = $FillTypeContainer/SquareFillType

const LAYOUT_DIRECTION_TEXT : StringName = "[center]Layout Direction[/center]"
@onready var layout_direction_rich_text : SettingsManagedRichTextLabel = $LayoutDirectionRichTextLabel
@onready var horizontal_direction_button : Button = $LayoutDirectionContainer1/HorizontalDirection
@onready var vertical_direction_button : Button = $LayoutDirectionContainer1/VerticalDirection
@onready var downward_direction_button : Button = $LayoutDirectionContainer2/DownwardDirection
@onready var upward_direction_button : Button = $LayoutDirectionContainer2/UpwardDirection

var custom_gradient : CustomGradient

# Get which custom theme we are operating on and set everything up from there.
func _ready():
	blend_rich_text.set_text_and_resize_y(BLEND_TYPE_TEXT)
	fill_rich_text.set_text_and_resize_y(FILL_TYPE_TEXT)
	layout_direction_rich_text.set_text_and_resize_y(LAYOUT_DIRECTION_TEXT)
	theme_list_item.die_theme = DieImageManager.THEME.CUSTOM
	DieImageManager.custom_gradient_changed.connect(reconfigure)
	reconfigure()
	
func reconfigure() -> void:
	theme_list_item.reconfigure()
	custom_gradient = DieImageManager.get_custom_gradient()
	match_buttons_to_gradient()
	
func update_gradient() -> void:
	DieImageManager.set_custom_gradient(custom_gradient)
	
func match_buttons_to_gradient() -> void:
	# Do our blend type buttons
	match custom_gradient.blend_type:
		CustomGradient.BLEND_TYPE.LINEAR:
			linear_blend_button.button_pressed = true
			constant_blend_button.button_pressed = false
		CustomGradient.BLEND_TYPE.CONSTANT:
			linear_blend_button.button_pressed = false
			constant_blend_button.button_pressed = true
			
	# Do our fill type buttons
	match custom_gradient.fill_type:
		CustomGradient.FILL_TYPE.LINEAR:
			linear_fill_button.button_pressed = true
			radial_fill_button.button_pressed = false
			square_fill_button.button_pressed = false
		CustomGradient.FILL_TYPE.RADIAL:
			linear_fill_button.button_pressed = false
			radial_fill_button.button_pressed = true
			square_fill_button.button_pressed = false
		CustomGradient.FILL_TYPE.SQUARE:
			linear_fill_button.button_pressed = false
			radial_fill_button.button_pressed = false
			square_fill_button.button_pressed = true
			
	# Do our layout direction buttons
	match custom_gradient.layout_direction:
		CustomGradient.LAYOUT_DIRECTION.HORIZONTAL:
			horizontal_direction_button.button_pressed = true
			vertical_direction_button.button_pressed = false
			downward_direction_button.button_pressed = false
			upward_direction_button.button_pressed = false
		CustomGradient.LAYOUT_DIRECTION.VERTICAL:
			horizontal_direction_button.button_pressed = false
			vertical_direction_button.button_pressed = true
			downward_direction_button.button_pressed = false
			upward_direction_button.button_pressed = false
		CustomGradient.LAYOUT_DIRECTION.DIAGONAL_DOWN:
			horizontal_direction_button.button_pressed = false
			vertical_direction_button.button_pressed = false
			downward_direction_button.button_pressed = true
			upward_direction_button.button_pressed = false
		CustomGradient.LAYOUT_DIRECTION.DIAGONAL_UP:
			horizontal_direction_button.button_pressed = false
			vertical_direction_button.button_pressed = false
			downward_direction_button.button_pressed = false
			upward_direction_button.button_pressed = true
	

# Set the blend type to linear and update it.
func _on_linear_blend_type_pressed():
	custom_gradient.blend_type = CustomGradient.BLEND_TYPE.LINEAR
	update_gradient()

# Set the blend type to constant and update it.
func _on_constant_blend_type_pressed():
	custom_gradient.blend_type = CustomGradient.BLEND_TYPE.CONSTANT
	update_gradient()

# Set the fill type to linear and update it.
func _on_linear_fill_type_pressed():
	custom_gradient.fill_type = CustomGradient.FILL_TYPE.LINEAR
	update_gradient()

# Set the fill type to radial and update it.
func _on_radial_fill_type_pressed():
	custom_gradient.fill_type = CustomGradient.FILL_TYPE.RADIAL
	update_gradient()

# Set the fill type to square and update it.
func _on_square_fill_type_pressed():
	custom_gradient.fill_type = CustomGradient.FILL_TYPE.SQUARE
	update_gradient()

# Set the layout direction to horizontal and update it.
func _on_horizontal_direction_pressed():
	custom_gradient.layout_direction = CustomGradient.LAYOUT_DIRECTION.HORIZONTAL
	update_gradient()

# Set the layout direction to vertical and update it.
func _on_vertical_direction_pressed():
	custom_gradient.layout_direction = CustomGradient.LAYOUT_DIRECTION.VERTICAL
	update_gradient()

# Set the layout direction to downward and update it.
func _on_downward_direction_pressed():
	custom_gradient.layout_direction = CustomGradient.LAYOUT_DIRECTION.DIAGONAL_DOWN
	update_gradient()

# Set the layout direction to upward and update it.
func _on_upward_direction_pressed():
	custom_gradient.layout_direction = CustomGradient.LAYOUT_DIRECTION.DIAGONAL_UP
	update_gradient()
