extends PopupBase
class_name MinMaxDieDialog

@onready var name_margins : MarginContainer = $ContentPanel/Margins/VBoxContainer/NameMargins
@onready var die_name_label : SettingsManagedLabel = $ContentPanel/Margins/VBoxContainer/NameMargins/DieNameLabel
@onready var info_margins : MarginContainer = $ContentPanel/Margins/VBoxContainer/InfoMargins
@onready var horizontal_line : HSeparator = $ContentPanel/Margins/VBoxContainer/HSeparator
@onready var die_info_label : SettingsManagedRichTextLabel = $ContentPanel/Margins/VBoxContainer/InfoMargins/DieInfoLabel
@onready var min_margins : MarginContainer = $ContentPanel/Margins/VBoxContainer/MinMargins
@onready var min_label : SettingsManagedLabel = $ContentPanel/Margins/VBoxContainer/MinMargins/MinLayout/MinLabel
@onready var min_line_edit : LineEdit = $ContentPanel/Margins/VBoxContainer/MinMargins/MinLayout/MinLineEdit
@onready var max_margins : MarginContainer = $ContentPanel/Margins/VBoxContainer/MaxMargins
@onready var max_label : SettingsManagedLabel = $ContentPanel/Margins/VBoxContainer/MaxMargins/MaxLayout/MaxLabel
@onready var max_line_edit : LineEdit = $ContentPanel/Margins/VBoxContainer/MaxMargins/MaxLayout/MaxLineEdit
@onready var name_edit_margins : MarginContainer = $ContentPanel/Margins/VBoxContainer/NameEditMargins
@onready var name_label : SettingsManagedLabel = $ContentPanel/Margins/VBoxContainer/NameEditMargins/NameLayout/NameLabel
@onready var name_line_edit : LineEdit = $ContentPanel/Margins/VBoxContainer/NameEditMargins/NameLayout/NameLineEdit
@onready var button_row_margins : MarginContainer = $ContentPanel/Margins/VBoxContainer/ButtonRowMargins
@onready var accept_cancel_buttons : AcceptCancelButtons = $ContentPanel/Margins/VBoxContainer/ButtonRowMargins/ButtonRowLayout/AcceptCancelButtons
@onready var remove_confirm_button : RemoveConfirmButton = $ContentPanel/Margins/VBoxContainer/ButtonRowMargins/ButtonRowLayout/RemoveConfirmButton

var first_set_die : MinMaxDie = SimpleRollManager.default_min_max_die
var m_min_max_die : MinMaxDie = SimpleRollManager.default_min_max_die

signal die_accepted(original_die: MinMaxDie, accepted_die: MinMaxDie)
signal die_removed(removed_die: MinMaxDie)

# Set the y size the heights of all the margins.
func set_content_panel_minimum_size():
	
	var content_height = 0
	
	content_height += name_margins.size.y
	# Needed to properly grab the size of the die info label
	info_margins.reset_size()
	content_height += info_margins.size.y
	content_height += horizontal_line.size.y
	content_height += min_margins.size.y
	content_height += max_margins.size.y
	content_height += name_edit_margins.size.y
	content_height += button_row_margins.size.y
	
	content_panel.custom_minimum_size.y = content_height
	
	# Have the max grab the focus, but don't change size from default.
	max_line_edit.grab_focus()
	max_line_edit.select_all()

# Sets the visibility of the remove button.
# When you are first creating a die, remove doesn't make sense.
func set_remove_button_visibility(show_hide: bool):
	remove_confirm_button.visible = show_hide

# Set the dice to the given die, update text lines, and highlight issues.
# if first_set is true, will forcefully update the text lines.
func set_min_max_die(die: MinMaxDie, first_set : bool = true):
	if(first_set):
		first_set_die = die.duplicate()
	
	m_min_max_die = die
	
	die_name_label.text = m_min_max_die.name()
	die_info_label.set_text_and_resize_y(m_min_max_die.info())
	# Don't mess with text they can change if something is there.
	if(min_line_edit.text.is_empty() or first_set):
		min_line_edit.text = str(m_min_max_die.minimum())
	if(max_line_edit.text.is_empty() or first_set):
		max_line_edit.text = str(m_min_max_die.maximum())
	if(first_set):
		if(die.name() == m_min_max_die.default_name()):
			name_line_edit.text = ""
		else:
			name_line_edit.text = die.name()
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
		set_min_max_die(m_min_max_die, false)
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
		emit_signal("die_accepted", first_set_die.duplicate(), m_min_max_die.duplicate())
		animate_close_popup()

func _on_remove_confirm_button_remove_confirmed():
	emit_signal("die_removed", m_min_max_die.duplicate())
	animate_close_popup()
