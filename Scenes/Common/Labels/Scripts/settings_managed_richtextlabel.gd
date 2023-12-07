extends RichTextLabel
class_name SettingsManagedRichTextLabel

# When a positive number, will only allow a set number of lines to be shown.
# All other lines will be scrollable only.
@export var max_lines_shown : int = -1

# When set to true, will always display all lines.
# Overrides max_lines_shown.
@export var enforce_all_lines_shown : bool = false

func _ready():
	SettingsManager.reconfigure.connect(reconfigure)
	call_deferred("reconfigure")
	
# Reconfigures the scene according to the settings
func reconfigure():
	var display_lines = 1
	
	if(max_lines_shown > display_lines):
		display_lines = min(get_line_count(), max_lines_shown)
		
	if(enforce_all_lines_shown):
		display_lines = get_line_count()
	
	var font_size = get_theme_font_size("font_size", theme_type_variation)
	var needed_pixel_height = get_theme_default_font().get_height(font_size) * display_lines
	custom_minimum_size.y = needed_pixel_height

func set_text_and_resize_y(bbcode: String) -> void:
	text = bbcode
	reconfigure()
