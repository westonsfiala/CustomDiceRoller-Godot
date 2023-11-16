extends PopupBase
class_name MinMaxDieDialog

@onready var die_name_label : Label = $ContentPanel/Margins/VBoxContainer/NameMargins/DieNameLabel
@onready var die_info_label : Label = $ContentPanel/Margins/VBoxContainer/InfoMargins/DieInfoLabel
@onready var max_line_edit : LineEdit = $ContentPanel/Margins/VBoxContainer/MaxMargins/MaxLayout/MaxLineEdit
@onready var name_line_edit : LineEdit = $ContentPanel/Margins/VBoxContainer/NameEditMargins/NameLayout/NameLineEdit

var m_min_max_die : MinMaxDie

func set_content_panel_minimum_size():
	# Have the max grab the focus, but don't change size from default.
	max_line_edit.grab_focus()

func set_min_max_die(die: MinMaxDie):
	m_min_max_die = die
	set_text()
	
func set_text():
	if(m_min_max_die):
		die_name_label.text = m_min_max_die.name()
		die_info_label.text = m_min_max_die.info()
		name_line_edit.placeholder_text = m_min_max_die.default_name()
