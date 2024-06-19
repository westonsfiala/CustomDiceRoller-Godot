extends PopupBase
class_name DieSelectorPopup

@onready var dice_button_container : VBoxContainer = $ContentPanel/Margins/DiceScroller/DiceButtonContainer

signal die_pressed(die : AbstractDie)

# When called will query the simple roll manager for the dice that are available and will fill out buttons accordingly
func configure_buttons() -> void:
	SettingsManager.remove_and_free_children(dice_button_container)
	var dice : Array[AbstractDie] = SimpleRollManager.get_dice()
	for die : AbstractDie in dice:
		var die_selector_button : DieSelectorButton = preload("res://Scenes/Common/Buttons/die_selector_button.tscn").instantiate()
		dice_button_container.add_child(die_selector_button)
		die_selector_button.configure(die)
		die_selector_button.die_selected.connect(die_selected)
	
func set_content_panel_minimum_size() -> void:
	var three_fourths_window_size : Vector2 = SettingsManager.get_window_size() * 3 / 4
	var dice_heights : int = SimpleRollManager.get_dice().size() * SettingsManager.get_button_size()
	var dice_widths : int = SettingsManager.get_button_size() * 7 # Its a rough estimate of how big stuff is.
	var min_height : int = min(three_fourths_window_size.y, dice_heights)
	var min_width : int = min(three_fourths_window_size.x, dice_widths)
	
	var popup_size : Vector2i = Vector2i(min_width, min_height)
	content_panel.custom_minimum_size = popup_size

func die_selected(die : AbstractDie) -> void:
	emit_signal("die_pressed", die)
	animate_close_popup()
	