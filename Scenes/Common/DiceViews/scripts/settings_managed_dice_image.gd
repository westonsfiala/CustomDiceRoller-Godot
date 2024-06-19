extends TextureRect
class_name SettingsManagedDiceImage

@export var use_setting_size : bool = true

var m_negate_color : bool = false

# Setup all the signals that will manage what we look like.
func _ready() -> void:
	SettingsManager.dice_size_changed.connect(reconfigure_image)
	SettingsManager.dice_tint_color_changed.connect(reconfigure_image)
	SettingsManager.dice_theme_changed.connect(reconfigure_image)
	SettingsManager.color_negation_enabled_changed.connect(reconfigure_image)
	reconfigure_image()
	
func configure_image(new_texture: Texture2D) -> void:
	texture = new_texture
	
func reconfigure_image() -> void:
	if use_setting_size:
		var vector_size : Vector2 = Vector2.ONE * SettingsManager.get_dice_size()
		custom_minimum_size = vector_size
		size = vector_size
		pivot_offset = size/2
	
	material.set_shader_parameter("TintColor", SettingsManager.get_dice_tint_color())
	var die_theme_texture : Texture2D = DieImageManager.get_theme_texture(SettingsManager.get_dice_theme())
	material.set_shader_parameter("Theme", die_theme_texture)
	
	if SettingsManager.get_color_negation_enabled():
		material.set_shader_parameter("NegateColor", m_negate_color)
	else:
		material.set_shader_parameter("NegateColor", false)

func set_negate_color(negate: bool) -> void:
	m_negate_color = negate
	reconfigure_image()
