extends HBoxContainer
class_name ThemeListItem

@export var die_theme : DieImageManager.THEME = DieImageManager.THEME.WHITE

@onready var preview_die_view: TextureRect = $PreviewDieView
@onready var select_button: Button = $SelectButton
@onready var theme_text: SettingsManagedRichTextLabel = $SelectButton/ThemeRichTextLabel
@onready var randomize_button: Button = $RandomizeButton
@onready var preview_color_rect: ColorRect = $PreviewColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	SettingsManager.button_size_changed.connect(reconfigure)
	reconfigure()
	
func is_random():
	return die_theme == DieImageManager.THEME.RANDOM or die_theme == DieImageManager.THEME.RANDOM_MATCHING
	
func reconfigure():
	# Set the name and the texture.
	var theme_name = str("[center]", DieImageManager.get_theme_name_from_enum(die_theme), "[/center]")
	theme_text.set_text_and_resize_y(theme_name)
	var selected_theme_texture = DieImageManager.get_theme_texture(die_theme)
	preview_die_view.material.set_shader_parameter("Theme", selected_theme_texture)
	preview_color_rect.material.set_shader_parameter("Theme", selected_theme_texture)
	
	# Only show the randomize button when we we are random.
	randomize_button.visible = is_random()
	
	# Get all the button sizes correct.
	var button_size = SettingsManager.get_button_size() * 1.5
	var vector_button_size = Vector2.ONE * button_size
	preview_die_view.custom_minimum_size = vector_button_size
	select_button.custom_minimum_size.y = button_size
	randomize_button.custom_minimum_size = vector_button_size
	preview_color_rect.custom_minimum_size = vector_button_size
	custom_minimum_size.y = 0

# Set the theme to the selected theme.
func _on_select_button_pressed():
	SettingsManager.set_dice_theme(die_theme)
	reconfigure()

# When the randomize button is pressed, refresh the display.
func _on_randomize_button_pressed():
	DieImageManager.randomize_random_match()
	_on_select_button_pressed()
