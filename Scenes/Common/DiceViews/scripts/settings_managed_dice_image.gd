extends TextureRect
class_name SettingsManagedDiceImage


# Setup all the signals that will manage what we look like.
func _ready():
	SettingsManager.dice_size_changed.connect(reconfigure_image)
	SettingsManager.dice_tint_color_changed.connect(reconfigure_image)
	reconfigure_image()
	
func reconfigure_image():
	var vector_size = Vector2.ONE * SettingsManager.get_dice_size()
	custom_minimum_size = vector_size
	size = vector_size
	pivot_offset = size/2
	
	self_modulate = SettingsManager.get_dice_tint_color()

