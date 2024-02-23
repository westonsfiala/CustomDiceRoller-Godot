extends PopupBase
class_name WordDieDialog

@onready var name_margins : MarginContainer = $ContentPanel/Margins/VBoxContainer/NameMargins
@onready var die_name_label : SettingsManagedLabel = $ContentPanel/Margins/VBoxContainer/NameMargins/DieNameLabel
@onready var info_margins : MarginContainer = $ContentPanel/Margins/VBoxContainer/InfoMargins
@onready var horizontal_line : HSeparator = $ContentPanel/Margins/VBoxContainer/HSeparator
@onready var die_info_label : SettingsManagedRichTextLabel = $ContentPanel/Margins/VBoxContainer/InfoMargins/DieInfoLabel
@onready var faces_margins : MarginContainer = $ContentPanel/Margins/VBoxContainer/FacesMargins
@onready var faces_label : SettingsManagedLabel = $ContentPanel/Margins/VBoxContainer/FacesMargins/FacesLayout/FacesLabel
@onready var faces_line_edit : LineEdit = $ContentPanel/Margins/VBoxContainer/FacesMargins/FacesLayout/FacesLineEdit
@onready var name_edit_margins : MarginContainer = $ContentPanel/Margins/VBoxContainer/NameEditMargins
@onready var name_label : SettingsManagedLabel = $ContentPanel/Margins/VBoxContainer/NameEditMargins/NameLayout/NameLabel
@onready var name_line_edit : LineEdit = $ContentPanel/Margins/VBoxContainer/NameEditMargins/NameLayout/NameLineEdit
@onready var button_row_margins : MarginContainer = $ContentPanel/Margins/VBoxContainer/ButtonRowMargins
@onready var accept_cancel_buttons : AcceptCancelButtons = $ContentPanel/Margins/VBoxContainer/ButtonRowMargins/ButtonRowLayout/AcceptCancelButtons
@onready var remove_confirm_button : RemoveConfirmButton = $ContentPanel/Margins/VBoxContainer/ButtonRowMargins/ButtonRowLayout/RemoveConfirmButton

var first_set_die : WordDie = SimpleRollManager.default_word_die
var m_word_die : WordDie = SimpleRollManager.default_word_die

signal die_accepted(original_die: NonNumberDie, accepted_die: NonNumberDie)
signal die_removed(removed_die: NonNumberDie)

func _ready():
	die_info_label.resized.connect(deferred_helper)
	super()

# Sets the minimum size to display all content
func _inner_set_size():
	var content_height = 0
	
	# If you don't set their size, the margins report incorrect numbers.
	name_margins.size.y = 0
	info_margins.size.y = 0
	name_edit_margins.size.y = 0
	faces_margins.size.y = 0
	button_row_margins.size.y = 0
	
	content_height += name_margins.size.y
	# Needed to properly grab the size of the die info label
	content_height += info_margins.size.y
	content_height += horizontal_line.size.y
	content_height += name_edit_margins.size.y
	content_height += faces_margins.size.y
	content_height += button_row_margins.size.y
	
	content_panel.custom_minimum_size.y = content_height
	# Need this step to force any size shrinks to take effect.
	content_panel.size.y = 0
	enforce_content_panel_in_screen(size/2, true)
	
# Set the y size the heights of all the margins.
func set_content_panel_minimum_size():
	_inner_set_size()
	# Have the max grab the focus, but don't change size from default.
	faces_line_edit.grab_focus()
	faces_line_edit.select_all()

# Sets the visibility of the remove button.
# When you are first creating a die, remove doesn't make sense.
func set_remove_button_visibility(show_hide: bool):
	remove_confirm_button.visible = show_hide

# Function pair to help make resizing the dialog work.
# If you don't have this and the method it calls, the dialog won't respect size changes
# to the die info label.
func deferred_helper():
	call_deferred("helper")
	
func helper():
	die_info_label.reconfigure()
	_inner_set_size()

# Set the dice to the given die, update text lines, and highlight issues.
# if first_set is true, will forcefully update the text lines.
func set_word_die(die: WordDie, first_set : bool = true):
	if(first_set):
		first_set_die = die.duplicate()
	
	m_word_die = die
	
	die_name_label.text = m_word_die.name()
	die_info_label.set_text_and_resize_y(m_word_die.info())
	# Don't mess with text they can change if something is there.
	if(faces_line_edit.text.is_empty() or first_set):
		var face_text = ",".join(m_word_die.get_faces())
		faces_line_edit.text = face_text
		
	if(first_set):
		if(die.name() == m_word_die.default_name()):
			name_line_edit.text = ""
		else:
			name_line_edit.text = die.name()
	name_line_edit.placeholder_text = m_word_die.default_name()
	_inner_set_size()
	
# Any time a line edit is changed, update text highlighting and enable/disable the accept button
func _line_edit_text_changed(_text: String):
	var update_die = true
	
	var die_name = name_line_edit.text
	var die_faces = faces_line_edit.text
	
	var good_state = true
	var faces_array: Array[String] = []
	for face in die_faces.split(","):
		var stripped_faces = face.strip_edges()
		if !stripped_faces.is_empty():
			faces_array.push_back(stripped_faces)
		else:
			good_state = false
			break
			
	if good_state:
		if(faces_line_edit.has_theme_color_override("font_color")):
			faces_line_edit.remove_theme_color_override("font_color")
	else:
		update_die = false
		faces_line_edit.add_theme_color_override("font_color", Color.RED)
	
	if update_die:
		m_word_die.configure(die_name, faces_array)
		accept_cancel_buttons.enable_accept()
		set_word_die(m_word_die, false)
	else:
		accept_cancel_buttons.disable_accept()

# If someone hits enter, try to click the accept button.
func _line_edit_text_submitted(_text: String):
	_on_accept_cancel_buttons_accept_pressed()

# They canceled, close it up.
func _on_accept_cancel_buttons_cancel_pressed():
	animate_close_popup()

# If we are in a good state to accept, let it accept and close. Otherwise nothing.
func _on_accept_cancel_buttons_accept_pressed():
	if(accept_cancel_buttons.can_accept()):
		emit_signal("die_accepted", first_set_die.duplicate(), m_word_die.duplicate())
		animate_close_popup()

func _on_remove_confirm_button_remove_confirmed():
	emit_signal("die_removed", m_word_die.duplicate())
	animate_close_popup()
