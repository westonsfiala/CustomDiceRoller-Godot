extends Control
class_name FullScreenResult

@onready var roll_detailed_name_label : SettingsManagedRichTextLabel = $MarginContainer/TextAndButtonLayout/ScrollContainer/DisplayTextLayout/RollDetailsRichText
@onready var sum_label : SettingsManagedRichTextLabel = $MarginContainer/TextAndButtonLayout/ScrollContainer/DisplayTextLayout/SumRichTextLabel
@onready var roll_results_label : SettingsManagedRichTextLabel = $MarginContainer/TextAndButtonLayout/ScrollContainer/DisplayTextLayout/RollResultsRichTextLabel
@onready var date_time_label : SettingsManagedRichTextLabel = $MarginContainer/TextAndButtonLayout/DateTimeRichText
@onready var reroll_button : LongPressButton = $MarginContainer/TextAndButtonLayout/HBoxContainer/RerollButton
@onready var exit_button : LongPressButton = $MarginContainer/TextAndButtonLayout/HBoxContainer/ExitButton

var m_result : RollResults = RollResults.new()

signal finished()
signal reroll()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SettingsManager.window_size_changed.connect(reconfigure)
	SettingsManager.button_size_changed.connect(reconfigure)
	reconfigure()
	
func configure(result: RollResults) -> FullScreenResult:
	m_result = result
	return self
	
func reconfigure() -> void:
	var button_size: int = SettingsManager.get_button_size()
	
	reroll_button.custom_minimum_size.y = button_size
	exit_button.custom_minimum_size.y = button_size
	
	# First up is the details
	roll_detailed_name_label.set_text_and_resize_y(str("[center]", m_result.roll_detailed_name_text, "[/center]"))
	
	# Don't need to worry about the height of the date and time as they are fixed in upper right
	date_time_label.set_text_and_resize_y(str("[right]", m_result.date_string, " ", m_result.time_string, "[/right]"))
	date_time_label.custom_minimum_size.x = date_time_label.get_content_width()
	
	# Give our sum label its width and initial height. 
	sum_label.set_text_and_resize_y(str("[center]", m_result.roll_sum.formatted_text, "[/center]"))
	
	# Go through all of the different lists that can be generated
	var first : bool = true
	var combined_text : String = "[center]"
	for result : ColoredDieResults in m_result.roll_results_array:
		if(not first):
			combined_text += "\n"
		first = false
		combined_text += result.formatted_text
	combined_text += "[/center]"
	
	roll_results_label.set_text_and_resize_y(combined_text)

# Send out the reroll signal
func _on_reroll_button_pressed() -> void:
	emit_signal("reroll", m_result)

# Send out the exit signal
func _on_exit_button_pressed() -> void:
	emit_signal("finished")
