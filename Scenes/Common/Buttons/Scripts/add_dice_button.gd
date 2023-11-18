extends Control
class_name AddDiceButton

@onready var add_dice_popup_menu : AddDicePopupMenu = $AddDicePopupMenu
@onready var min_max_die_dialog : MinMaxDieDialog = $MinMaxDieDialog

signal reset_dice()
signal die_accepted(die: AbstractDie)

func _on_add_button_pressed():
	add_dice_popup_menu.modular_popup(get_screen_position())
	
func _on_add_dice_popup_menu_reset_dice():
	emit_signal("reset_dice")

func _on_add_dice_popup_menu_new_min_max_die():
	min_max_die_dialog.set_min_max_die(SimpleRollManager.default_min_max_die)
	min_max_die_dialog.modular_popup_center()

func _on_add_dice_popup_menu_new_imbalanced_die():
	pass # Replace with function body.

func _on_add_dice_popup_menu_new_non_number_die():
	pass # Replace with function body.

func _on_min_max_die_dialog_die_accepted(accepted_die):
	emit_signal("die_accepted", accepted_die)
