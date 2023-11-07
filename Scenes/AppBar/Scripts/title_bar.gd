extends Control

@onready var clear_history_button : LongPressButton = $MarginContainer/ClearHistoryButton

func _on_clear_history_button_short_pressed():
	var popup_menu = PopupMenu.new()
	popup_menu.theme = preload("res://Resources/Styles/default_theme.tres")
	popup_menu.add_item("Clear History")
	popup_menu.connect("id_pressed", clear_history)
	popup_menu.popup_exclusive(clear_history_button, clear_history_button.get_rect())
	
func clear_history(_id):
	RollManager.clear_roll_history()

