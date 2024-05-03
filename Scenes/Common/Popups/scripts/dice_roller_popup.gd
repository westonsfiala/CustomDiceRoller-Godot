extends PopupBase
class_name DiceRollerPopup

@onready var dice_roller : DiceRoller = $ContentPanel/Margins/DiceRoller

signal finished_animated_roll(roll_results: RollResults)
	
func set_content_panel_minimum_size() -> void:
	var screen_size : Vector2 = SettingsManager.get_window_size()
	var half_screen_square_size : Vector2 = Vector2.ONE * min(screen_size.x, screen_size.y) / 2
	content_panel.custom_minimum_size = half_screen_square_size

func _on_clear_history_confirm_button_pressed() -> void:
	emit_signal("clear_history_pressed")
	animate_close_popup()

func _on_dice_roller_finished_animated_roll(roll_results: RollResults) -> void:
	emit_signal("finished_animated_roll", roll_results)
