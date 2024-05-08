extends CollapsibleSettingBase
class_name SortTypeSetting

@onready var natural_button : Button = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/SortTypeContainer/NaturalButton
@onready var ascending_button : Button = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/SortTypeContainer/AscendingButton
@onready var descending_button : Button = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/SortTypeContainer/DescendingButton
@onready var button_container : HBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/SortTypeContainer

const SORT_TYPE_LABEL_TEXT : String = "Sort Type - "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SettingsManager.sort_type_changed.connect(reconfigure_buttons)
	reconfigure_buttons()
	
# Make sure the buttons are nice and visible.
func reconfigure_buttons() -> void:
	match SettingsManager.get_sort_type():
		SettingsManager.SORT_TYPE.NATURAL:
			natural_button.button_pressed = true
			ascending_button.button_pressed = false
			descending_button.button_pressed = false
		SettingsManager.SORT_TYPE.ASCENDING:
			natural_button.button_pressed = false
			ascending_button.button_pressed = true
			descending_button.button_pressed = false
		SettingsManager.SORT_TYPE.DESCENDING:
			natural_button.button_pressed = false
			ascending_button.button_pressed = false
			descending_button.button_pressed = true
	
	show_hide_reset_button()
	set_title()
	
# Method for inherited class to get the title to display
func inner_get_title() -> String:
	var sort_type_string : String = ''
	
	match SettingsManager.get_sort_type():
		SettingsManager.SORT_TYPE.NATURAL:
			sort_type_string = "Natural"
		SettingsManager.SORT_TYPE.ASCENDING:
			sort_type_string = "Ascending"
		SettingsManager.SORT_TYPE.DESCENDING:
			sort_type_string = "Descending"
	return str(SORT_TYPE_LABEL_TEXT, sort_type_string)

# Method for inherited class to get the minimum height of the collapsible section
func inner_get_collapsible_section_minimum_height() -> int:
	return int(button_container.size.y)
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return SettingsManager.get_sort_type() != SettingsManager.SORT_TYPE_DEFAULT

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed() -> void:
	SettingsManager.set_sort_type(SettingsManager.SORT_TYPE_DEFAULT)
	emit_signal("setting_changed")

# Set the sort type to natural.
func _on_natural_button_pressed() -> void:
	SettingsManager.set_sort_type(SettingsManager.SORT_TYPE.NATURAL)
	emit_signal("setting_changed")

# Set the sort type to ascending.
func _on_ascending_button_pressed() -> void:
	SettingsManager.set_sort_type(SettingsManager.SORT_TYPE.ASCENDING)
	emit_signal("setting_changed")

# Set the sort type to descending.
func _on_descending_button_pressed() -> void:
	SettingsManager.set_sort_type(SettingsManager.SORT_TYPE.DESCENDING)
	emit_signal("setting_changed")
