extends PopupBase
class_name SaveRollPopup

@onready var top_vertical_layout : VBoxContainer = $ContentPanel/Margins/VerticalLayout
@onready var roll_name_line_edit : LineEdit = $ContentPanel/Margins/VerticalLayout/RollNameLineEditLayout/RollNameLineEdit
@onready var roll_category_line_edit : LineEdit = $ContentPanel/Margins/VerticalLayout/RollCategoryLineEditLayout/CategoryLineEdit
@onready var accept_cancel_buttons : AcceptCancelButtons = $ContentPanel/Margins/VerticalLayout/AcceptCancelButtons

signal roll_saved(saved_roll: CustomRollModel)

var m_roll_model : CustomRollModel = CustomRollModel.new()

# Set the content size to be at maximum 3/4th of the screen
func set_content_panel_minimum_size() -> void:
	var three_fourths_window_size : Vector2 = SettingsManager.get_window_size() * 3 / 4
	var min_height : float = min(three_fourths_window_size.y, top_vertical_layout.size.y)
	var min_width : float = min(three_fourths_window_size.x, top_vertical_layout.size.x)
	
	var popup_size : Vector2 = Vector2(min_width, min_height)
	content_panel.custom_minimum_size = popup_size

# Set the initial value of the popup. Required to be called to save nicely.
func set_initial_value(roll_model : CustomRollModel) -> void:
	m_roll_model = roll_model
	roll_name_line_edit.text = m_roll_model.m_name
	roll_category_line_edit.text = m_roll_model.m_category
	_on_roll_name_line_edit_text_changed(roll_name_line_edit.text)
	roll_name_line_edit.grab_focus()

# When the accept is pressed, emit that we have something to save and close.
func _on_accept_cancel_buttons_accept_pressed() -> void:
	if(accept_cancel_buttons.can_accept()):
		m_roll_model.m_name = roll_name_line_edit.text
		m_roll_model.m_category = roll_category_line_edit.text
		emit_signal("roll_saved", m_roll_model)
		animate_close_popup()

# Close out of the popup without doing anything.
func _on_accept_cancel_buttons_cancel_pressed() -> void:
	animate_close_popup()

# If we ever submit, try to do an accept.
func _on_roll_name_line_edit_text_submitted(_new_text:String) -> void:
	_on_accept_cancel_buttons_accept_pressed()

# When the roll name is changed, make sure it is not empty.
func _on_roll_name_line_edit_text_changed(new_text:String) -> void:
	if(not new_text.is_empty()):
		if(roll_name_line_edit.has_theme_color_override("font_color")):
			roll_name_line_edit.remove_theme_color_override("font_color")
		accept_cancel_buttons.enable_accept()
	else:
		roll_name_line_edit.add_theme_color_override("font_color", Color.RED)
		accept_cancel_buttons.disable_accept()

# If we ever submit, try to do an accept.
func _on_category_line_edit_text_submitted(_new_text:String) -> void:
	_on_accept_cancel_buttons_accept_pressed()
