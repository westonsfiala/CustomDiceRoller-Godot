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

const REPEAT_TEXT : StringName = "[center]Repeat[/center]"
@onready var repeat_rich_text : SettingsManagedRichTextLabel = $RepeatRichTextLabel
@onready var repeat_slider : HSlider = $RepeatSliderContainer/RepeatSlider
@onready var no_repeat_button : Button = $RepeatTypeContainer/NoRepeatButton
@onready var repeat_button : Button = $RepeatTypeContainer/RepeatButton
@onready var mirror_button : Button = $RepeatTypeContainer/MirrorRepeatButton

const COLOR_TEXT : StringName = "[center]Colors[/center]"
@onready var colors_rich_text : SettingsManagedRichTextLabel = $ColorsRichTextLabel
@onready var colors_container : VBoxContainer = $ColorsContainer

var custom_gradient : CustomGradient

# Get which custom theme we are operating on and set everything up from there.
func _ready():
	blend_rich_text.set_text_and_resize_y(BLEND_TYPE_TEXT)
	fill_rich_text.set_text_and_resize_y(FILL_TYPE_TEXT)
	layout_direction_rich_text.set_text_and_resize_y(LAYOUT_DIRECTION_TEXT)
	layout_direction_rich_text.set_text_and_resize_y(REPEAT_TEXT)
	colors_rich_text.set_text_and_resize_y(COLOR_TEXT)
	theme_list_item.die_theme = DieImageManager.THEME.CUSTOM
	repeat_slider.min_value = CustomGradient.REPEAT_MIN
	repeat_slider.max_value = CustomGradient.REPEAT_MAX
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
	
	# Process the slider with no signaling
	repeat_slider.set_value_no_signal(custom_gradient.repeat_num)
	
	# Set the repeat type buttons
	match custom_gradient.repeat_type:
		CustomGradient.REPEAT_TYPE.NO_REPEAT:
			no_repeat_button.button_pressed = true
			repeat_button.button_pressed = false
			mirror_button.button_pressed = false
		CustomGradient.REPEAT_TYPE.REPEAT:
			no_repeat_button.button_pressed = false
			repeat_button.button_pressed = true
			mirror_button.button_pressed = false
		CustomGradient.REPEAT_TYPE.MIRROR_REPEAT:
			no_repeat_button.button_pressed = false
			repeat_button.button_pressed = false
			mirror_button.button_pressed = true
			
	# Set the colors
	var colors = custom_gradient.colors
	var color_list_items = colors_container.get_children()
	
	# Add or remove items that we no longer need
	while colors.size() > color_list_items.size():
		var new_color_list_item : ColorPickerListItem = preload("res://Scenes/SettingsPage/color_picker_list_item.tscn").instantiate()
		new_color_list_item.up_pressed.connect(_on_color_picker_list_item_up_pressed)
		new_color_list_item.down_pressed.connect(_on_color_picker_list_item_down_pressed)
		new_color_list_item.remove_pressed.connect(_on_color_picker_list_item_remove_pressed)
		new_color_list_item.color_changed.connect(_on_color_picker_list_item_color_changed)
		colors_container.add_child(new_color_list_item)
		color_list_items = colors_container.get_children()
	
	while colors.size() < color_list_items.size():
		var item_to_remove = color_list_items.back()
		colors_container.remove_child(item_to_remove)
		item_to_remove.queue_free()
		color_list_items = colors_container.get_children()
		
	# Set the colors to match what the gradient has
	for index in color_list_items.size():
		var color = custom_gradient.colors[index]
		var color_list_item = color_list_items[index]
		color_list_item.set_color(color)
		color_list_item.set_index(index)
	

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

# Set the repeat num to the new value and update it.
func _on_repeat_slider_value_changed(value):
	custom_gradient.repeat_num = value
	update_gradient()

# Set the repeat type to no repeat and update it.
func _on_no_repeat_button_pressed():
	custom_gradient.repeat_type = CustomGradient.REPEAT_TYPE.NO_REPEAT
	update_gradient()

# Set the repeat type to repeat and update it.
func _on_repeat_button_pressed():
	custom_gradient.repeat_type = CustomGradient.REPEAT_TYPE.REPEAT
	update_gradient()

# Set the repeat type to mirror repeat and update it.
func _on_mirror_repeat_button_pressed():
	custom_gradient.repeat_type = CustomGradient.REPEAT_TYPE.MIRROR_REPEAT
	update_gradient()

# When a color picker item has up pressed, move that color up in the list.
func _on_color_picker_list_item_up_pressed(index: int):
	# Don't try to move something up that is already at the top.
	if index > 0 and index < custom_gradient.colors.size():
		var moved_color = custom_gradient.colors[index]
		custom_gradient.colors.remove_at(index)
		custom_gradient.colors.insert(index - 1, moved_color)
		update_gradient()

# When a color picker item has down pressed, move that color down in the list.
func _on_color_picker_list_item_down_pressed(index: int):
	# Don't try to move something down that is already at the bottom.
	if index > -1 and index < custom_gradient.colors.size()-1:
		var moved_color = custom_gradient.colors[index]
		custom_gradient.colors.remove_at(index)
		custom_gradient.colors.insert(index+1, moved_color)
		update_gradient()

# When a color picker item has remove pressed, remove that color from the list.
func _on_color_picker_list_item_remove_pressed(index: int):
	if index > -1 and index < custom_gradient.colors.size():
		custom_gradient.colors.remove_at(index)
		update_gradient()

# When a color picker item changes, update the color.
func _on_color_picker_list_item_color_changed(index: int, new_color: Color):
	if index > -1 and index < custom_gradient.colors.size():
		custom_gradient.colors[index] = new_color
		update_gradient()

# When the add color button is pressed, add a new color list item
func _on_add_color_button_pressed():
	custom_gradient.colors.append(Color.WHITE)
	update_gradient()
