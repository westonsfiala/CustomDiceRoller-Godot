extends Control

@onready var clear_history_button : LongPressButton = $MarginContainer/ClearHistoryButton
@onready var clear_history_popup : ClearHistoryPopup = $ClearHistoryPopup

func _on_clear_history_button_pressed():
	clear_history_popup.modular_popup(clear_history_button.get_screen_position())

func _on_clear_history_popup_clear_history_pressed():
	RollManager.clear_roll_history()
