extends PopupBase
class_name ClearHistoryPopup

@onready var clear_history_button : LongPressButton = $ContentPanel/Margins/ClearHistoryConfirmButton

signal clear_history_pressed()
	
func set_content_panel_minimum_size() -> void:
	content_panel.custom_minimum_size = Vector2i(200,SettingsManager.get_button_size())

func _on_clear_history_confirm_button_pressed() -> void:
	emit_signal("clear_history_pressed")
	animate_close_popup()
