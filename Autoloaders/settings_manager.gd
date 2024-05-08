extends Node

const DICE_SIZE_DEFAULT: int = 150
var dice_size : int = DICE_SIZE_DEFAULT

const DICE_TINT_COLOR_DEFAULT: Color = Color(1,1,1,0)
var dice_tint_color : Color = DICE_TINT_COLOR_DEFAULT

const DICE_THEME_DEFAULT: DieImageManager.THEME = DieImageManager.THEME.WHITE
var dice_theme : DieImageManager.THEME = DICE_THEME_DEFAULT

enum ROLL_CONTAINER_SIZE { FULLSCREEN, DIALOG, MINIMAL }
const ROLL_CONTAINER_SIZE_DEFAULT: ROLL_CONTAINER_SIZE = ROLL_CONTAINER_SIZE.FULLSCREEN
var roll_container_size : ROLL_CONTAINER_SIZE = ROLL_CONTAINER_SIZE_DEFAULT

const ANIMATIONS_ENABLED_DEFAULT: bool = true
var animations_enabled : bool = ANIMATIONS_ENABLED_DEFAULT

const MIN_MAX_HIGHLIGHT_ENABLED_DEFAULT: bool = true
var min_max_highlight_enabled : bool = MIN_MAX_HIGHLIGHT_ENABLED_DEFAULT

enum SORT_TYPE { NATURAL, ASCENDING, DESCENDING }
const SORT_TYPE_DEFAULT: SORT_TYPE = SORT_TYPE.NATURAL
var sort_type : SORT_TYPE = SORT_TYPE_DEFAULT

const BUTTON_SIZE_DEFAULT: int = 50
var button_size : int = BUTTON_SIZE_DEFAULT

const SHAKE_VOLUME_DEFAULT: int = 100
const SHAKE_AUDIO_BUS_NAME: StringName = "Shake"
var shake_volume : int = SHAKE_VOLUME_DEFAULT

const FONT_SIZE_SMALL_DEFAULT: int = 24
var font_size_small : int = FONT_SIZE_SMALL_DEFAULT

const FONT_SIZE_NORMAL_DEFAULT: int = 32
var font_size_normal : int = FONT_SIZE_NORMAL_DEFAULT

const FONT_SIZE_LARGE_DEFAULT: int = 40
var font_size_large : int = FONT_SIZE_LARGE_DEFAULT

const FONT_SIZE_HUGE_DEFAULT: int = 60
var font_size_huge : int = FONT_SIZE_HUGE_DEFAULT

const LONG_PRESS_DELAY : float = 0.5

enum SCENE {SETTINGS, HISTORY, SIMPLE_ROLL, NUM_SCENES}

var default_label_settings : LabelSettings = preload("res://Resources/Styles/normal_label.tres")

const SAVE_FILE_NAME : StringName = "user://settings_manager.save"

func _ready() -> void:
	load_state()
	
# Save the state of the simple roll manager to its save file.
func save_state() -> void:
	# Open the save file for writing.
	var settings_manager_save_file : FileAccess = FileAccess.open(SAVE_FILE_NAME, FileAccess.WRITE)
	
	# Start generating the save state dict.
	var save_dict : Dictionary = {}
	
	# Not sure if I need a schema version, but can't hurt to have.
	save_dict['schema_version'] = "1.0.0"
	save_dict['class_name'] = "SettingsManager"
	
	# Save the properties.
	save_dict['dice_size'] = dice_size
	save_dict['dice_tint_color'] = dice_tint_color.to_html()
	save_dict['dice_theme'] = dice_theme
	save_dict['roll_container_size'] = roll_container_size
	save_dict['animations_enabled'] = animations_enabled
	save_dict['min_max_highlight_enabled'] = min_max_highlight_enabled
	save_dict['sort_type'] = sort_type
	save_dict['button_size'] = button_size
	save_dict['shake_volume'] = shake_volume
	save_dict['font_size_small'] = font_size_small
	save_dict['font_size_normal'] = font_size_normal
	save_dict['font_size_large'] = font_size_large
	save_dict['font_size_huge'] = font_size_huge
	
	# Turn the dict into a string.
	var json_string : String = JSON.stringify(save_dict)
	
	# Save it into the file
	settings_manager_save_file.store_line(json_string)
	
# Load our state from our save file.
func load_state() -> void:
	# If not save file is present, use the defaults.
	if not FileAccess.file_exists(SAVE_FILE_NAME):
		print("No settings manager save file detected.")
		return
	
	# Load our save file and start parsing it.F
	var settings_manager_save_file : FileAccess = FileAccess.open(SAVE_FILE_NAME, FileAccess.READ)
	while settings_manager_save_file.get_position() < settings_manager_save_file.get_length():
		
		# Grab a line and parse it. We should only ever have one line.
		var json_string : String = settings_manager_save_file.get_line()
		var json : JSON = JSON.new()
		
		# If something goes wrong, print a message and bail.
		var parse_results : Error = json.parse(json_string)
		if not parse_results == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return
		
		# Get the data from the JSON object
		var save_data: Dictionary = json.get_data()
			
		if save_data['schema_version'] != "1.0.0":
			print("Unknown schema_version found during settings_manager loader: ", save_data['schema_version'])
		
		set_dice_size(save_data.get('dice_size', DICE_SIZE_DEFAULT))
		set_dice_tint_color(Color.from_string(save_data.get('dice_tint_color', Color.WHITE.to_html()), Color.WHITE))
		set_dice_theme(save_data.get('dice_theme', DICE_THEME_DEFAULT))
		set_roll_container_size(save_data.get('roll_container_size', ROLL_CONTAINER_SIZE_DEFAULT))
		set_animations_enabled(save_data.get('animations_enabled', ANIMATIONS_ENABLED_DEFAULT))
		set_min_max_highlight_enabled(save_data.get('min_max_highlight_enabled', MIN_MAX_HIGHLIGHT_ENABLED_DEFAULT))
		set_sort_type(save_data.get('sort_type', SORT_TYPE_DEFAULT))
		set_button_size(save_data.get('button_size', BUTTON_SIZE_DEFAULT))
		set_shake_volume(save_data.get('shake_volume', SHAKE_VOLUME_DEFAULT))
		set_font_size_small(save_data.get('font_size_small', FONT_SIZE_SMALL_DEFAULT))
		set_font_size_normal(save_data.get('font_size_normal', FONT_SIZE_NORMAL_DEFAULT))
		set_font_size_large(save_data.get('font_size_large', FONT_SIZE_LARGE_DEFAULT))
		set_font_size_huge(save_data.get('font_size_huge', FONT_SIZE_HUGE_DEFAULT))

# Signal emitted when the window size changes
signal window_size_changed()

# trigger for telling the settings manager that window size has changed.
func trigger_window_size_change() -> void:
	print("triggering window size change")
	emit_signal("window_size_changed")

# Gets the window size from the display server
func get_window_size() -> Vector2:
	return DisplayServer.window_get_size()
	
# Gets the default app scene, the simple roll page.
func get_default_app_scene() -> int:
	return SCENE.SIMPLE_ROLL

# Gets the the display name from the given enum
func get_scene_name(scene_enum: SCENE) -> String:
	match scene_enum:
		SCENE.SETTINGS: 
			return "Settings"
		SCENE.HISTORY: 
			return "History"
		SCENE.SIMPLE_ROLL: 
			return "Simple Roll"
		_:
			return "TEMP"
			
# Gets the number of scrollable scenes, used for coordinating scrollers
func get_num_scrollable_scenes() -> int:
	return SCENE.NUM_SCENES

# Signal to say that the given scene needs to be activated
signal navigate_to_scene(scene: SCENE)

# Triggers the navigate_to_scene signal to all listeners
func set_scrolled_scene(scene: SCENE) -> void:
	emit_signal("navigate_to_scene", scene)

# Signal for coordinating scroll value for the display bar
signal scene_scroll_value_changed(value: int)

# Sends out the signal that the scene scroll has changed
func set_scene_scroll_value(value: int) -> void:
	emit_signal("scene_scroll_value_changed", value)

# Signal for saying that the dice size has changed
signal dice_size_changed()
	
# Sets the new dice size and emits the dice_size_changed signal
func set_dice_size(new_dice_size: int) -> void:
	dice_size = new_dice_size
	emit_signal("dice_size_changed")
	save_state()
	
# Gets the dice size
func get_dice_size() -> int:
	return dice_size
	
# Signal for saying that the dice tint has changed
signal dice_tint_color_changed()
	
# Sets the new color tint and emits the dice_tint_color_changed signal
func set_dice_tint_color(new_dice_tint_color: Color) -> void:
	dice_tint_color = new_dice_tint_color
	emit_signal("dice_tint_color_changed")
	save_state()
	
# Gets the dice tint color
func get_dice_tint_color() -> Color:
	return dice_tint_color
	
# Signal for saying that the dice theme has changed
signal dice_theme_changed()
	
# Sets the new theme and emits the dice_theme_changed signal
func set_dice_theme(new_dice_theme: DieImageManager.THEME) -> void:
	dice_theme = new_dice_theme
	emit_signal("dice_theme_changed")
	save_state()
	
# Gets the dice theme
func get_dice_theme() -> DieImageManager.THEME:
	return dice_theme
	
# Signal for saying that the roll container sizing has changed
signal roll_container_size_changed()
	
# Sets the new roll container size and emits the roll_container_size_changed signal
func set_roll_container_size(new_roll_container_size: ROLL_CONTAINER_SIZE) -> void:
	roll_container_size = new_roll_container_size
	emit_signal("roll_container_size_changed")
	save_state()
	
# Gets the dice theme
func get_roll_container_size() -> ROLL_CONTAINER_SIZE:
	return roll_container_size
	
# Signal for saying that the animation enabled setting has changed
signal animations_enabled_changed()
	
# Enables or disables the animations and emits the animations_enabled_changed signal
func set_animations_enabled(enabled: bool) -> void:
	animations_enabled = enabled
	emit_signal("animations_enabled_changed")
	save_state()
	
# Gets if animations are enabled
func get_animations_enabled() -> bool:
	return animations_enabled
	
# Signal for saying that the min max highlight enabled setting has changed
signal min_max_highlight_enabled_changed()
	
# Enables or disables the min max highlight and emits the min_max_highlight_enabled_changed signal
func set_min_max_highlight_enabled(enabled: bool) -> void:
	min_max_highlight_enabled = enabled
	emit_signal("min_max_highlight_enabled_changed")
	save_state()
	
# Gets if min max highlight is enabled
func get_min_max_highlight_enabled() -> bool:
	return min_max_highlight_enabled
	
# Signal for saying that the sort type has changed
signal sort_type_changed()
	
# Sets the new sort type and emits the sort_type_changed signal
func set_sort_type(new_sort_type: SORT_TYPE) -> void:
	sort_type = new_sort_type
	emit_signal("sort_type_changed")
	save_state()
	
# Gets the sort type
func get_sort_type() -> SORT_TYPE:
	return sort_type
	
# Signal for saying that the button size has changed
signal button_size_changed()

# Sets the button size to the new size and emits button_size_changed
func set_button_size(new_button_size: int) -> void:
	button_size = new_button_size
	emit_signal("button_size_changed")
	save_state()
	
# Gets the button size
func get_button_size() -> int:
	return button_size
	
# Signal for saying that the shake volume has changed
signal shake_volume_changed()

# Sets the shake volume to the new volume and emits shake_volume_changed
func set_shake_volume(new_shake_volume: int) -> void:
	shake_volume = new_shake_volume
	var bus_index : int = AudioServer.get_bus_index(SHAKE_AUDIO_BUS_NAME)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(new_shake_volume / 100.0))
	emit_signal("shake_volume_changed")
	save_state()
	
# Gets the shake volume
func get_shake_volume() -> int:
	return shake_volume

# Signal for saying that the font size has changed
signal font_size_changed()

# Sets the small font size to the new size and emits font_size_changed
func set_font_size_small(new_font_size: int) -> void:
	font_size_small = new_font_size
	emit_signal("font_size_changed")
	save_state()

# Sets the normal font size to the new size and emits font_size_changed
func set_font_size_normal(new_font_size: int) -> void:
	font_size_normal = new_font_size
	emit_signal("font_size_changed")
	save_state()

# Sets the large font size to the new size and emits font_size_changed
func set_font_size_large(new_font_size: int) -> void:
	font_size_large = new_font_size
	emit_signal("font_size_changed")
	save_state()

# Sets the huge font size to the new size and emits font_size_changed
func set_font_size_huge(new_font_size: int) -> void:
	font_size_huge = new_font_size
	emit_signal("font_size_changed")
	save_state()

# Gets the small font size
func get_font_size_small() -> int:
	return font_size_small
	
# Gets the normal font size
func get_font_size_normal() -> int:
	return font_size_normal
	
# Gets the large font size
func get_font_size_large() -> int:
	return font_size_large
	
# Gets the huge font size
func get_font_size_huge() -> int:
	return font_size_huge

# Signal for triggering a fake mouse press
signal mouse_unpress()

# Trigger a fake mouse unpress. Used for making popups play nice.
func fake_mouse_unpress() -> void:
	emit_signal("mouse_unpress")

# Removes all the children nodes of a given node and frees them
func remove_and_free_children(node: Node) -> void:
	if node:
		for n : Node in node.get_children():
			node.remove_child(n)
			n.queue_free()
