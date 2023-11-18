extends PopupBase
class_name MinMaxDieDialog

@onready var die_name_label : Label = $ContentPanel/Margins/VBoxContainer/NameMargins/DieNameLabel
@onready var die_info_label : Label = $ContentPanel/Margins/VBoxContainer/InfoMargins/DieInfoLabel
@onready var min_line_edit : LineEdit = $ContentPanel/Margins/VBoxContainer/MinMargins/MinLayout/MinLineEdit
@onready var max_line_edit : LineEdit = $ContentPanel/Margins/VBoxContainer/MaxMargins/MaxLayout/MaxLineEdit
@onready var name_line_edit : LineEdit = $ContentPanel/Margins/VBoxContainer/NameEditMargins/NameLayout/NameLineEdit
@onready var accept_cancel_buttons : AcceptCancelButtons = $ContentPanel/Margins/VBoxContainer/AcceptCancelButtons

var m_min_max_die : MinMaxDie = SimpleRollManager.default_min_max_die

signal die_accepted(accepted_die: MinMaxDie)

# Use the default size that is setup in the editor. Use this to grab focus to the most edited line.
func set_content_panel_minimum_size():
	# Have the max grab the focus, but don't change size from default.
	max_line_edit.grab_focus()
	max_line_edit.select_all()

# Set the dice to the given die, update text lines, and highlight issues.
func set_min_max_die(die: MinMaxDie):
	m_min_max_die = die
	
	die_name_label.text = m_min_max_die.name()
	die_info_label.text = m_min_max_die.info()
	# Don't mess with text they can change if something is there.
	if(min_line_edit.text.is_empty()):
		min_line_edit.text = str(m_min_max_die.minimum())
	if(max_line_edit.text.is_empty()):
		max_line_edit.text = str(m_min_max_die.maximum())
	name_line_edit.placeholder_text = m_min_max_die.default_name()

# Any time a line edit is changed, update text highlighting and enable/disable the accept button
func _line_edit_text_changed(_new_text: String):
	var update_die = true
	
	var die_name = name_line_edit.text
	var die_min_value = min_line_edit.text
	if(die_min_value.is_valid_int()):
		if(min_line_edit.has_theme_color_override("font_color")):
			min_line_edit.remove_theme_color_override("font_color")
	else:
		update_die = false
		min_line_edit.add_theme_color_override("font_color", Color.RED)
		
	var die_max_value = max_line_edit.text
	if(die_max_value.is_valid_int()):
		if(max_line_edit.has_theme_color_override("font_color")):
			max_line_edit.remove_theme_color_override("font_color")
	else:
		update_die = false
		max_line_edit.add_theme_color_override("font_color", Color.RED)
	
	if update_die:
		m_min_max_die.configure(die_name, die_min_value.to_int(), die_max_value.to_int())
		accept_cancel_buttons.enable_accept()
		set_min_max_die(m_min_max_die)
	else:
		accept_cancel_buttons.disable_accept()

# If someone hits enter, try to click the accept button.
func _line_edit_text_submitted(_new_text: String):
	_on_accept_cancel_buttons_accept_pressed()

# They canceled, close it up.
func _on_accept_cancel_buttons_cancel_pressed():
	animate_close_popup()

# If we are in a good state to accept, let it accept and close. Otherwise nothing.
func _on_accept_cancel_buttons_accept_pressed():
	if(accept_cancel_buttons.can_accept()):
		emit_signal("die_accepted", m_min_max_die.duplicate())
		animate_close_popup()
