extends PopupBase
class_name MinimalRollResultsPopup

@onready var roll_results_rich_text_label : SettingsManagedRichTextLabel = $ContentPanel/Margins/RollResultRichTextLabel

@onready var auto_close_timer : Timer = $AutoCloseTimer

const AUTO_CLOSE_TIME : float = 3.0

# Called when the popup is created and ready to be shown
func set_content_panel_minimum_size() -> void:
	# Make the width the whole screen, and the height at minimum button height
	var window_size : Vector2 = SettingsManager.get_window_size()
	var minimum_height : float = max(roll_results_rich_text_label.custom_minimum_size.y, SettingsManager.get_button_size())
	content_panel.custom_minimum_size = Vector2(window_size.x, minimum_height)

# Set the roll results and display them in the rich text label
func set_roll_results(roll_results : RollResults) -> void:
	var colored_results : String = roll_results.roll_sum.formatted_text
	roll_results_rich_text_label.set_text_and_resize_y(str("[center]", colored_results, "[/center]"))

# When the timer goes off, close the popup
func _on_auto_close_timer_timeout() -> void:
	animate_close_popup()

# need to stop this from going off if we were already closed.
func animate_close_popup() -> void:
	auto_close_timer.stop()
	super()

# Override this method to also create a timer that we use to close the popup after a certain amount of time
func _on_about_to_popup() -> void:
	auto_close_timer.start(AUTO_CLOSE_TIME)
	super()
	
