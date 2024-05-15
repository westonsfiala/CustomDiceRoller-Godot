extends HBoxContainer
class_name ColorPickerListItem

@onready var color_picker_button : ColorPickerButton = $ColorPickerButton

# Used for signaling.
var index : int = -1

signal color_changed(index: int, new_color: Color)
signal up_pressed(index: int)
signal down_pressed(index: int)
signal remove_pressed(index: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var picker : ColorPicker = color_picker_button.get_picker()
	picker.picker_shape = ColorPicker.SHAPE_NONE
	picker.can_add_swatches = false
	picker.sampler_visible = false
	picker.color_modes_visible = false
	picker.presets_visible = false
	SettingsManager.window_size_changed.connect(reconfigure)
	reconfigure()
	
# Change the size of the picker when the window size changes.
func reconfigure() -> void:
	var picker : ColorPicker = color_picker_button.get_picker()
	picker.custom_minimum_size.x = SettingsManager.get_window_size().x/2

# Set the color without a signal.
func set_color(new_color: Color) -> void:
	color_picker_button.color = new_color
	
# Set the index to the new index.
func set_index(new_index: int) -> void:
	index = new_index

# Send that this list item should be moved up.
func _on_up_button_pressed() -> void:
	emit_signal("up_pressed", index)

# Send that this list item should be moved down.
func _on_down_button_pressed() -> void:
	emit_signal("down_pressed", index)
	
# Send that this list item should be removed.
func _on_remove_button_pressed() -> void:
	# Without this the signal is sent before the mouse unpress event is processed.
	call_deferred("remove_button_helper")

# Helper method for removing self. 
func remove_button_helper() -> void:
	emit_signal("remove_pressed", index)

# Send that we have a new color to use.
func _on_color_picker_button_color_changed(new_color: Color) -> void:
	set_color(new_color)
	emit_signal("color_changed", index, new_color)

# When the popups close it seems to do odd stuff with scrolling, a fake unpress makes it better.
func _on_color_picker_button_popup_closed() -> void:
	SettingsManager.fake_mouse_unpress()
