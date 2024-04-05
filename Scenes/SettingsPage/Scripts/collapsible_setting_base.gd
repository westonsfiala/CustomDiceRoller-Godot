extends Control
class_name CollapsibleSettingBase

@onready var top_level_container : VBoxContainer = $TopLevelContainer
@onready var title_bar_container : HBoxContainer = $TopLevelContainer/TitleBarContainer
@onready var rotating_arrow : SettingsManagedTextureButton = $TopLevelContainer/TitleBarContainer/RotatingArrow
@onready var setting_name_label : SettingsManagedRichTextLabel = $TopLevelContainer/TitleBarContainer/CollapseExpandButton/SettingName
@onready var reset_button : Button = $TopLevelContainer/TitleBarContainer/ResetButton
@onready var collapsible_section : Control = $TopLevelContainer/CollapsibleContainer/CollapsibleSection
@onready var collapsible_container : HBoxContainer = $TopLevelContainer/CollapsibleContainer

const RIGHT_ARROW : Texture2D = preload("res://Icons/right-arrow.svg")
const DOWN_ARROW : Texture2D = preload("res://Icons/down-arrow.svg") 
const COLLAPSED_SCALE_VECTOR : Vector2 = Vector2(1,0)
const EXPANDED_SCALE_VECTOR : Vector2 = Vector2.ONE

var tween : Tween

signal reset_pressed()
signal setting_changed()

# Connect to the setting we will be modifying
func _ready():
	# If you don't call both of these, it doesnt seem to work...
	start_collapsed()
	call_deferred("start_collapsed")
	
# Get the safe minimum collapsible height. Max of button size and inner height.
func get_safe_collabible_section_minimum_height() -> int:
	var button_size: int = SettingsManager.get_button_size()
	return max(inner_get_collapsible_section_minimum_height(), button_size)
	
# Start with the setting collapsed
func start_collapsed():
	rotating_arrow.set_new_button_texture(RIGHT_ARROW)
	set_title()
	show_hide_reset_button()
	
	collapsible_container.visible = true
	collapsible_section.visible = true
	
	collapsible_section.scale = COLLAPSED_SCALE_VECTOR
	collapsible_section.custom_minimum_size.y = 0
	collapsible_section.size.y = 0
	
	collapsible_container.custom_minimum_size.y = 0
	collapsible_container.size.y = 0
	
	collapsible_container.visible = false
	collapsible_section.visible = false
	call_deferred("enforce_all_content_shown")

# Toggle showing/hiding the dice settings.
func expand_collapse_inner_settings():
	var collapsible_full_height = get_safe_collabible_section_minimum_height()
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	# Collapse things down
	if collapsible_container.visible:
		tween.tween_property(rotating_arrow, "rotation_degrees", -90, SettingsManager.LONG_PRESS_DELAY).from(0)
		tween.tween_method(set_content_scale, EXPANDED_SCALE_VECTOR, COLLAPSED_SCALE_VECTOR, SettingsManager.LONG_PRESS_DELAY)
		tween.tween_method(set_collapsible_min_height, collapsible_full_height, 0, SettingsManager.LONG_PRESS_DELAY)
		tween.chain().tween_callback(finish_hide_setting_callback)
	# Expand things out
	else:
		collapsible_section.visible = true
		collapsible_container.visible = true
		tween.tween_property(rotating_arrow, "rotation_degrees", 90, SettingsManager.LONG_PRESS_DELAY).from(0)
		tween.tween_method(set_content_scale, COLLAPSED_SCALE_VECTOR, EXPANDED_SCALE_VECTOR, SettingsManager.LONG_PRESS_DELAY)
		tween.tween_method(set_collapsible_min_height, 0, collapsible_full_height, SettingsManager.LONG_PRESS_DELAY)
		tween.chain().tween_callback(finish_show_setting_callback)

func set_content_scale(new_scale: Vector2):
	collapsible_section.scale = new_scale
	for child in collapsible_section.get_children(true):
		child.scale = new_scale
		child.pivot_offset = child.size/2

# Method for setting the height of the content when its expanding / collapsing
func set_collapsible_min_height(current_content_height: int):
	collapsible_section.custom_minimum_size.y = current_content_height
	collapsible_section.size.y = current_content_height
	enforce_all_content_shown()

# At the end of the collapse, this gets called.
func finish_hide_setting_callback():
	collapsible_section.visible = false
	collapsible_container.visible = false
	rotating_arrow.rotation_degrees = 0
	rotating_arrow.set_new_button_texture(RIGHT_ARROW)
	enforce_all_content_shown()
	
# At the end of the expand, this gets called.
func finish_show_setting_callback():
	rotating_arrow.rotation_degrees = 0
	rotating_arrow.set_new_button_texture(DOWN_ARROW)
	enforce_all_content_shown()

# Method for having the proper size of the setting at all times.
func enforce_all_content_shown():
	title_bar_container.size.y = 0
	collapsible_container.size.y = 0
	custom_minimum_size.y = title_bar_container.size.y + collapsible_container.size.y

# Shows or hides the reset button as dictacted by inner_should_show_reset_button
func show_hide_reset_button():
	reset_button.visible = inner_should_show_reset_button()
	
func signal_reset_pressed():
	inner_reset_button_pressed()
	emit_signal("reset_pressed")
	
func set_title():
	setting_name_label.set_text_and_resize_y(inner_get_title())
	
func inner_get_title() -> String:
	return "Temp"
	
# Method for inherited class to get the minimum height of the collapsible section
func inner_get_collapsible_section_minimum_height() -> int:
	return 0
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return true

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed():
	pass
