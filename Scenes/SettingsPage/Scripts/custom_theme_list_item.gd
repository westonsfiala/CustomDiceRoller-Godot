extends VBoxContainer
class_name CustomThemeListItem

@export_range(1,3,1)
var custom_theme_index : int = 1

# Display theme
@onready var theme_list_item : ThemeListItem = $ThemeListItem

@onready var linear_blend_button : Button = $BlendTypeContainer/LinearType
@onready var constant_blend_button : Button = $BlendTypeContainer/ConstantType

var custom_gradient : CustomGradient

# Get which custom theme we are operating on and set everything up from there.
func _ready():
	match custom_theme_index:
		1: 
			theme_list_item.die_theme = DieImageManager.THEME.CUSTOM_1
			SettingsManager.custom_gradient_1_changed.connect(reconfigure)
		2:
			theme_list_item.die_theme = DieImageManager.THEME.CUSTOM_2
			SettingsManager.custom_gradient_2_changed.connect(reconfigure)
		3:
			theme_list_item.die_theme = DieImageManager.THEME.CUSTOM_3
			SettingsManager.custom_gradient_3_changed.connect(reconfigure)
	reconfigure()
	
func reconfigure() -> void:
	theme_list_item.reconfigure()
	match custom_theme_index:
		1: 
			custom_gradient = SettingsManager.get_custom_gradient_1()
		2:
			custom_gradient = SettingsManager.get_custom_gradient_2()
		3:
			custom_gradient = SettingsManager.get_custom_gradient_3()
	match_buttons_to_gradient()
	
func update_gradient() -> void:
	match custom_theme_index:
		1: 
			SettingsManager.set_custom_gradient_1(custom_gradient)
		2:
			SettingsManager.set_custom_gradient_2(custom_gradient)
		3:
			SettingsManager.set_custom_gradient_3(custom_gradient)
	
func match_buttons_to_gradient() -> void:
	# Do our blend type buttons
	match custom_gradient.blend_type:
		CustomGradient.BLEND_TYPE.LINEAR:
			linear_blend_button.button_pressed = true
			constant_blend_button.button_pressed = false
		CustomGradient.BLEND_TYPE.CONSTANT:
			linear_blend_button.button_pressed = false
			constant_blend_button.button_pressed = true

# Set the blend type to linear and update it.
func _on_linear_type_pressed():
	custom_gradient.blend_type = CustomGradient.BLEND_TYPE.LINEAR
	update_gradient()

# Set the blend type to constant and update it.
func _on_constant_type_pressed():
	custom_gradient.blend_type = CustomGradient.BLEND_TYPE.CONSTANT
	update_gradient()
