extends MarginContainer
class_name HistoryItem

@onready var color_rect : ColorRect = $TopLayout/TopLineLayout/ColorRect
@onready var sum_label : SettingsManagedRichTextLabel = $TopLayout/TopLineLayout/ColorRect/SumRichTextLabel
@onready var roll_name_label : SettingsManagedRichTextLabel = $TopLayout/TopLineLayout/NameDetailLayout/RollNameRichText
@onready var roll_detailed_name_label : SettingsManagedRichTextLabel = $TopLayout/TopLineLayout/NameDetailLayout/RollDetailsRichText
@onready var date_label : SettingsManagedRichTextLabel = $TopLayout/TopLineLayout/DateTimeLayout/DateRichText
@onready var time_label : SettingsManagedRichTextLabel = $TopLayout/TopLineLayout/DateTimeLayout/TimeRichText
@onready var roll_results_label : SettingsManagedRichTextLabel = $TopLayout/RollResultsRichTextLabel

var m_result : RollResults = RollResults.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SettingsManager.window_size_changed.connect(reconfigure)
	call_deferred("reconfigure")
	
func configure(result: RollResults) -> HistoryItem:
	m_result = result
	return self
	
func reconfigure() -> void:
	
	# First up is the name, details, and datetime
	var name_layout_height : int = 0
	roll_name_label.set_text_and_resize_y(m_result.roll_name_text)
	roll_detailed_name_label.set_text_and_resize_y(m_result.roll_detailed_name_text)
	name_layout_height += roll_name_label.get_content_height()
	name_layout_height += roll_detailed_name_label.get_content_height()
	
	# Don't need to worry about the height of the date and time as they will only 
	# ever have one line and will be small text.
	date_label.set_text_and_resize_y(str("[right]", m_result.date_string, "[/right]"))
	date_label.custom_minimum_size.x = date_label.get_content_width()
	time_label.set_text_and_resize_y(str("[right]", m_result.time_string, "[/right]"))
	time_label.custom_minimum_size.x = time_label.get_content_width()
	
	# Give our label its width and initial height. 
	# When we set the text it will resize to make it centered vertically.
	sum_label.custom_minimum_size = Vector2(color_rect.size.x,name_layout_height)
	sum_label.set_text_and_resize_y(str("[center]", m_result.roll_sum.formatted_text, "[/center]"))
	var sum_label_needed_height : int = sum_label.get_content_height()
	
	# Set the minimum height to the maximum of the box and the text lines
	# If sum_label height is the deciding factor, give it a bit extra because otherwise
	# it will be too flush.
	if(sum_label_needed_height > name_layout_height):
		sum_label_needed_height += 5
	
	# Go through all of the different lists that can be generated
	var first : bool = true
	var combined_text : String = ""
	for result : ColoredDieResults in m_result.roll_results_array:
		if(not first):
			combined_text += "\n"
		first = false
		combined_text += result.formatted_text
	
	roll_results_label.set_text_and_resize_y(combined_text)

# Reroll from our result.
func _on_reroll_button_pressed() -> void:
	RollManager.reroll_from_results(m_result)

# Save our roll as a named roll.
func _on_save_button_pressed() -> void:
	# TODO: Need to get the save roll page going for this to work.
	pass # Replace with function body.
