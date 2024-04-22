extends HBoxContainer
class_name ThemeListItem

@export var die_theme_name : String = DieImageManager.get_theme_name_from_enum(DieImageManager.THEME.WHITE)
var die_theme : DieImageManager.THEME = DieImageManager.get_theme_enum_from_name(die_theme_name)

@onready var preview_die_view: TextureRect = $PreviewDieView
@onready var select_button: Button = $SelectButton
@onready var theme_text: SettingsManagedRichTextLabel = $SelectButton/ThemeRichTextLabel
@onready var preview_color_rect: ColorRect = $PreviewColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SettingsManager.button_size_changed.connect(reconfigure)
	die_theme = DieImageManager.get_theme_enum_from_name(die_theme_name)
	reconfigure()
	
func is_random_match() -> bool:
	return die_theme == DieImageManager.THEME.RANDOM_MATCHING
	
func reconfigure() -> void:
	# Set the name and the texture.
	var selected_theme_texture : Texture2D = DieImageManager.get_theme_texture(die_theme)
	preview_die_view.material.set_shader_parameter("Theme", selected_theme_texture)
	preview_color_rect.material.set_shader_parameter("Theme", selected_theme_texture)
	
	var theme_name : String = str("[center]", DieImageManager.get_theme_name_from_enum(die_theme), "[/center]")
	theme_text.set_text_and_resize_y(theme_name)
	
	# Get all the button sizes correct.
	var button_size : float = SettingsManager.get_button_size() * 1.5
	var vector_button_size : Vector2 = Vector2.ONE * button_size
	preview_die_view.custom_minimum_size = vector_button_size
	select_button.custom_minimum_size.y = button_size
	preview_color_rect.custom_minimum_size = vector_button_size
	custom_minimum_size.y = 0

# Set the theme to the selected theme.
# If we are random match, randomize ourselves.
func _on_select_button_pressed() -> void:
	if is_random_match() and die_theme == SettingsManager.get_dice_theme():
		DieImageManager.randomize_random_match()
	SettingsManager.set_dice_theme(die_theme)
	reconfigure()

# When the randomize button is pressed, refresh the display.
func _on_randomize_button_pressed() -> void:
	DieImageManager.randomize_random_match()
	_on_select_button_pressed()
