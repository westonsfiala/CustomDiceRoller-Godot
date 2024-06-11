extends RichTextLabel
class_name SettingsManagedRichTextLabel

# When a positive number, will only allow a set number of lines to be shown.
# All other lines will be scrollable only.
@export var max_lines_shown : int = -1

# When set to true, will always display all lines.
# Overrides max_lines_shown.
@export var enforce_all_lines_shown : bool = false

# When set to true, will scroll the text in a ticker formation like a radio.
@export var scroll_clipped_text : bool = true

# Save the set text so that we can apply scroll correctly.
var last_user_set_text : String = ""

func _ready() -> void:
	SettingsManager.window_size_changed.connect(reconfigure)
	resized.connect(reconfigure)
	last_user_set_text = text
	call_deferred("reconfigure")
	
# Reconfigures the scene according to the settings
func reconfigure() -> void:
	var display_lines : int = 1
	
	if(max_lines_shown > display_lines):
		display_lines = min(get_line_count(), max_lines_shown)
	
	# When we want to show all lines, force autowrap on.
	if(enforce_all_lines_shown):
		display_lines = get_line_count()
		autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	var font_size : int = get_theme_font_size("normal_font_size", theme_type_variation)
	var needed_pixel_height : int = int(get_theme_default_font().get_height(font_size) * display_lines)
	custom_minimum_size.y = needed_pixel_height
	
	# When we need to, scroll the text
	if(scroll_clipped_text and not enforce_all_lines_shown):
		var content_width : int = get_content_width()
		# Need to set and unset the scroll.
		if(content_width > size.x):
			var scroll_length : float = content_width - size.x
			var stipped_text : String = StringHelper.strip_directional_bbcode(last_user_set_text)
			text = str("[scroll length=",scroll_length,"]",stipped_text,"[/scroll]")
		else:
			text = last_user_set_text

func set_text_and_resize_y(bbcode: String) -> void:
	text = bbcode
	last_user_set_text = bbcode
	reconfigure()

func set_text_and_resize_y_centered(bbcode: String) -> void:
	set_text_and_resize_y(str("[center]", bbcode, "[/center]"))
