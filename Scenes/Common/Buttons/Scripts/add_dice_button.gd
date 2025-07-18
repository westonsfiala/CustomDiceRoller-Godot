extends HBoxContainer
class_name AddDiceButton

@onready var add_dice_popup_menu : AddDicePopupMenu = $AddDicePopupMenu
@onready var min_max_die_dialog : MinMaxDieDialog = $MinMaxDieDialog
@onready var imbalanced_die_dialog : ImbalancedDieDialog = $ImbalancedDieDialog
@onready var word_die_dialog : WordDieDialog = $WordDieDialog

signal reset_dice()
signal die_accepted(die: AbstractDie)

func _on_add_button_pressed() -> void:
	add_dice_popup_menu.modular_popup(get_screen_position())
	
func _on_add_dice_popup_menu_reset_dice() -> void:
	emit_signal("reset_dice")

func _on_add_dice_popup_menu_new_min_max_die() -> void:
	min_max_die_dialog.set_min_max_die(SimpleRollManager.default_min_max_die)
	min_max_die_dialog.set_remove_button_visibility(false)
	min_max_die_dialog.modular_popup_center()

func _on_add_dice_popup_menu_new_imbalanced_die() -> void:
	imbalanced_die_dialog.set_imbalanced_die(SimpleRollManager.default_imbalanced_die)
	imbalanced_die_dialog.set_remove_button_visibility(false)
	imbalanced_die_dialog.modular_popup_center()

func _on_add_dice_popup_menu_new_word_die() -> void:
	word_die_dialog.set_word_die(SimpleRollManager.default_word_die)
	word_die_dialog.set_remove_button_visibility(false)
	word_die_dialog.modular_popup_center()

func _on_min_max_die_dialog_die_accepted(_original_die: MinMaxDie, accepted_die: MinMaxDie) -> void:
	emit_signal("die_accepted", accepted_die)

func _on_imbalanced_die_dialog_die_accepted(_original_die: ImbalancedDie, accepted_die: ImbalancedDie) -> void:
	emit_signal("die_accepted", accepted_die)

func _on_word_die_dialog_die_accepted(_original_die: WordDie, accepted_die: WordDie) -> void:
	emit_signal("die_accepted", accepted_die)
