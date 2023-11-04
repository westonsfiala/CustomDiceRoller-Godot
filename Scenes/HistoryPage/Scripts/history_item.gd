extends Control
class_name HistoryItem

@onready var color_rect : ColorRect = $MarginContainer/TopLayout/TopLineLayout/ColorRect
@onready var sum_label : SettingsManagedRichTextLabel = $MarginContainer/TopLayout/TopLineLayout/ColorRect/SumRichTextLabel
@onready var roll_name_label : Label = $MarginContainer/TopLayout/TopLineLayout/NameDetailLayout/RollNameLabel
@onready var roll_detailed_name_label : Label = $MarginContainer/TopLayout/TopLineLayout/NameDetailLayout/RollDetailsLabel
@onready var date_label : Label = $MarginContainer/TopLayout/TopLineLayout/DateTimeLayout/DateLabel
@onready var time_label : Label = $MarginContainer/TopLayout/TopLineLayout/DateTimeLayout/TimeLabel
@onready var roll_results_label : RichTextLabel = $MarginContainer/TopLayout/RollResultsRichTextLabel

var m_result : RollResults = RollResults.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	SettingsManager.reconfigure.connect(deferred_reconfigure)
	deferred_reconfigure()
	
func configure(result: RollResults) -> HistoryItem:
	m_result = result
	deferred_reconfigure()
	return self
	
func deferred_reconfigure():
	call_deferred("reconfigure")
	
func reconfigure():
	print("reconfigure history item")
	var minimum_height = 0
	var min_text_height = SettingsManager.get_text_size()
	
	# Parse though the top line items.
	# First up is the box with the sum.
	var top_line_minimum_height = min_text_height * 2
	sum_label.clear()
	sum_label.push_paragraph(HORIZONTAL_ALIGNMENT_CENTER)
	sum_label.append_text(m_result.roll_sum.formatted_text)
	sum_label.pop()
	var sum_label_height = max(sum_label.get_content_width(), sum_label.get_content_height(), top_line_minimum_height)
	color_rect.custom_minimum_size = Vector2.ONE * sum_label_height
	
	# Next up is the Name, Details, and by default the datetime
	var name_lines = 0
	roll_name_label.text = m_result.roll_name_text
	roll_detailed_name_label.text = m_result.roll_detailed_name_text
	name_lines += roll_name_label.get_line_count()
	name_lines += roll_detailed_name_label.get_line_count()
	# Don't need to count the date and time as they will only ever have one line
	date_label.text = m_result.date_string
	time_label.text = m_result.time_string
	
	# Set the minimum height to the maximum of the box and the text lines
	minimum_height = max(sum_label_height, min_text_height * name_lines)
	
	# Go through all of the different lists that can be generated
	var first = true
	var combined_text = ""
	for result in m_result.roll_results_array:
		if(not first):
			combined_text += "\n"
		first = false
		combined_text += result.formatted_text
	
	roll_results_label.clear()
	roll_results_label.push_paragraph(HORIZONTAL_ALIGNMENT_LEFT)
	roll_results_label.append_text(combined_text)
	roll_results_label.pop()
	
	var roll_results_height = max(roll_results_label.get_content_height(), min_text_height)
	roll_results_label.custom_minimum_size.y = roll_results_height
	minimum_height += roll_results_height
	
	custom_minimum_size.y = minimum_height
