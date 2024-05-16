extends Control
class_name CollapsibleSettingBase

@onready var top_level_container : VBoxContainer = $TopLevelContainer
@onready var title_bar_container : HBoxContainer = $TopLevelContainer/TitleBarContainer
@onready var rotating_arrow : SettingsManagedTextureButton = $TopLevelContainer/TitleBarContainer/RotatingArrow
@onready var setting_name_label : SettingsManagedRichTextLabel = $TopLevelContainer/TitleBarContainer/CollapseExpandButton/SettingName
@onready var reset_button : Button = $TopLevelContainer/TitleBarContainer/ResetButton
@onready var collapsible_section : VBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection
@onready var collapsible_container : HBoxContainer = $TopLevelContainer/CollapsibleContainer

const RIGHT_ARROW : Texture2D = preload("res://Icons/right-arrow.svg")
const DOWN_ARROW : Texture2D = preload("res://Icons/down-arrow.svg") 
const COLLAPSED_SCALE_VECTOR : Vector2 = Vector2(1,0)
const EXPANDED_SCALE_VECTOR : Vector2 = Vector2.ONE

var tween : Tween

signal reset_pressed()
signal setting_changed()

# Connect to the setting we will be modifying
func _ready() -> void:
	helper_expand_collapse_inner_settings(false)
	set_title()
	show_hide_reset_button()

# Toggle showing/hiding the dice settings.
func expand_collapse_inner_settings() -> void:
	helper_expand_collapse_inner_settings(not collapsible_container.visible)

# Helper method where you can force it to expand or collapse
func helper_expand_collapse_inner_settings(expand: bool) -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	# Collapse things down
	if not expand:
		rotating_arrow.set_new_button_texture(DOWN_ARROW)
		tween.tween_property(rotating_arrow, "rotation_degrees", -90, SettingsManager.LONG_PRESS_DELAY).from(0)
		tween.tween_method(set_content_scale, EXPANDED_SCALE_VECTOR, COLLAPSED_SCALE_VECTOR, SettingsManager.LONG_PRESS_DELAY)
		tween.chain().tween_callback(finish_hide_setting_callback)
	# Expand things out
	else:
		rotating_arrow.set_new_button_texture(RIGHT_ARROW)
		collapsible_section.visible = true
		collapsible_container.visible = true
		tween.tween_property(rotating_arrow, "rotation_degrees", 90, SettingsManager.LONG_PRESS_DELAY).from(0)
		tween.tween_method(set_content_scale, COLLAPSED_SCALE_VECTOR, EXPANDED_SCALE_VECTOR, SettingsManager.LONG_PRESS_DELAY)
		tween.chain().tween_callback(finish_show_setting_callback)

func set_content_scale(new_scale: Vector2) -> void:
	collapsible_container.scale = new_scale

# At the end of the collapse, this gets called.
func finish_hide_setting_callback() -> void:
	collapsible_section.visible = false
	collapsible_container.visible = false
	rotating_arrow.rotation_degrees = 0
	rotating_arrow.set_new_button_texture(RIGHT_ARROW)
	
# At the end of the expand, this gets called.
func finish_show_setting_callback() -> void:
	rotating_arrow.rotation_degrees = 0
	rotating_arrow.set_new_button_texture(DOWN_ARROW)

# Shows or hides the reset button as dictacted by inner_should_show_reset_button
func show_hide_reset_button() -> void:
	reset_button.visible = inner_should_show_reset_button()
	
func signal_reset_pressed() -> void:
	inner_reset_button_pressed()
	emit_signal("reset_pressed")
	
func set_title() -> void:
	setting_name_label.set_text_and_resize_y(inner_get_title())
	
func inner_get_title() -> String:
	return "Temp"
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return true

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed() -> void:
	pass
