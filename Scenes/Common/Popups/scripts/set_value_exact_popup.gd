extends PopupBase
class_name SetValueExactPopup

@onready var set_text_label : SettingsManagedLabel = $ContentPanel/Margins/VerticalLayout/SetTextExactLabel
@onready var property_line_edit : LineEdit = $ContentPanel/Margins/VerticalLayout/LineEditLayout/PropertyLineEdit
@onready var accept_cancel_buttons : AcceptCancelButtons = $ContentPanel/Margins/VerticalLayout/AcceptCancelButtons

const set_value_text : String = "Set Value: "

signal value_changed(value: int)

# Set the content size to be at maximum 3/4th of the screen
func set_content_panel_minimum_size() -> void:
	var three_fourths_window_size : Vector2 = SettingsManager.get_window_size() * 3 / 4
	var min_height : float = min(three_fourths_window_size.y, content_panel.custom_minimum_size.y)
	var min_width : float = min(three_fourths_window_size.x, content_panel.custom_minimum_size.x)
	
	var popup_size : Vector2 = Vector2(min_width, min_height)
	content_panel.custom_minimum_size = popup_size
	
func set_initial_value(prop_name: String, value: int) -> void:
	set_text_label.text = str(set_value_text, prop_name)
	property_line_edit.text = str(value)
	_on_property_line_edit_text_changed(property_line_edit.text)
	property_line_edit.grab_focus()

func _on_accept_cancel_buttons_accept_pressed() -> void:
	if(accept_cancel_buttons.can_accept()):
		emit_signal("value_changed", property_line_edit.text.to_int())
		animate_close_popup()

func _on_accept_cancel_buttons_cancel_pressed() -> void:
	animate_close_popup()

func _on_property_line_edit_text_submitted(_new_text : String) -> void:
	_on_accept_cancel_buttons_accept_pressed()

func _on_property_line_edit_text_changed(new_text: String) -> void:
	if(new_text.is_valid_int()):
		if(property_line_edit.has_theme_color_override("font_color")):
			property_line_edit.remove_theme_color_override("font_color")
		accept_cancel_buttons.enable_accept()
	else:
		property_line_edit.add_theme_color_override("font_color", Color.RED)
		accept_cancel_buttons.disable_accept()
