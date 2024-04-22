extends PopupBase
class_name AddDicePopupMenu

@onready var layout : VBoxContainer = $ContentPanel/Margins/VBoxContainer

signal reset_dice()
signal new_min_max_die()
signal new_imbalanced_die()
signal new_word_die()

func set_content_panel_minimum_size() -> void:
	content_panel.custom_minimum_size.y = layout.get_child_count() * SettingsManager.get_button_size()

func _on_reset_dice_button_pressed() -> void:
	emit_signal("reset_dice")
	animate_close_popup()

func _on_min_max_die_button_pressed() -> void:
	emit_signal("new_min_max_die")
	animate_close_popup()

func _on_imbalanced_die_button_pressed() -> void:
	emit_signal("new_imbalanced_die")
	animate_close_popup()

func _on_non_number_die_button_pressed() -> void:
	emit_signal("new_word_die")
	animate_close_popup()
