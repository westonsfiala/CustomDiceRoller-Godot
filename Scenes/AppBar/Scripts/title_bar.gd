extends Control

@onready var clear_history_button : LongPressButton = $MarginContainer/ClearHistoryButton
@onready var clear_history_popup : PopupMenu = $ClearHistoryPopup

func _on_clear_history_button_short_pressed():
	clear_history_popup.popup(Rect2i(clear_history_button.get_screen_position(), Vector2i.ZERO))

func _on_clear_history_popup_id_pressed(_id):
	RollManager.clear_roll_history()
