extends Control

@onready var clear_history_button : LongPressButton = $MarginContainer/ClearHistoryButton
@onready var clear_history_popup : Popup = $ClearHistoryPopup
@onready var animation_player : AnimationPlayer = $ClearHistoryPopup/AnimationPlayer

func _on_clear_history_button_short_pressed():
	clear_history_popup.popup(Rect2i(clear_history_button.get_screen_position(), Vector2i.ZERO))

func _on_settings_managed_text_button_pressed():
	RollManager.clear_roll_history()
	clear_history_popup.hide()

func _on_clear_history_popup_about_to_popup():
	animation_player.play("popup")
