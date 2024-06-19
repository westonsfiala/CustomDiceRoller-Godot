extends Control
class_name CustomRoll

@onready var no_dice_label : Label = $NoDiceLabel
@onready var add_button : SettingsManagedTextButton = $VerticalLayout/AddSaveRollLayout/AddButton
@onready var custom_roll_item_container : VBoxContainer = $VerticalLayout/MarginContainer/ScrollContainer/CustomRollItemContainer
@onready var die_selector_popup : DieSelectorPopup = $DieSelectorPopup

# Connect to the settings manager and setup the scene with all of our dice
func _ready() -> void:
	SettingsManager.window_size_changed.connect(reconfigure)
	CustomRollManager.custom_roll_updated.connect(reconfigure_buttons)
	die_selector_popup.die_pressed.connect(add_die_to_custom_roll)
	reconfigure()
	reconfigure_buttons()

# Remove all of our currently set diced and place new ones
func reconfigure() -> void:
	custom_minimum_size.x = SettingsManager.get_window_size().x

func reconfigure_buttons() -> void:
	# Get the die prop pairs and start updating things
	var die_prop_pairs : Array[DiePropertyPair] = CustomRollManager.get_die_prop_pairs()
	var custom_roll_list_items : Array[Node] = custom_roll_item_container.get_children()
	
	# Add or remove items that we no longer need
	while die_prop_pairs.size() > custom_roll_list_items.size():
		var new_custom_roll_list_item : CustomRollListItem = preload("res://Scenes/CustomRoll/custom_roll_list_item.tscn").instantiate()
		custom_roll_item_container.add_child(new_custom_roll_list_item)
		new_custom_roll_list_item.up_pressed.connect(item_up_pressed)
		new_custom_roll_list_item.down_pressed.connect(item_down_presed)
		new_custom_roll_list_item.remove_pressed.connect(item_remove_pressed)
		new_custom_roll_list_item.properties_changed.connect(item_properties_changed)
		custom_roll_list_items = custom_roll_item_container.get_children()
	
	while die_prop_pairs.size() < custom_roll_list_items.size():
		var item_to_remove : Node = custom_roll_list_items.back()
		custom_roll_item_container.remove_child(item_to_remove)
		item_to_remove.queue_free()
		custom_roll_list_items = custom_roll_item_container.get_children()

	var custom_roll_item_size : int = custom_roll_list_items.size()
	# Set the die results to match what the die_result_sounds has
	for index : int in custom_roll_item_size:
		var die_prop_pair : DiePropertyPair = die_prop_pairs[index]
		var custom_roll_list_item : Node = custom_roll_list_items[index]
		custom_roll_list_item.set_index(index)
		custom_roll_list_item.set_die_property_pair(die_prop_pair)
		custom_roll_list_item.set_separator_visible(index != custom_roll_item_size - 1)

	if die_prop_pairs.size() == 0:
		no_dice_label.show()
	else:
		no_dice_label.hide()

# When a die is selected, add it to the custom roll manager.
func add_die_to_custom_roll(die : AbstractDie) -> void:
	CustomRollManager.add_die_to_custom_roll(die)

# Set of helper methods for sending signals to the custom roll manager.
# You can't connect to the custom roll manager directly because it's doesn't work for reasons?
func item_up_pressed(index : int) -> void:
	CustomRollManager.move_die_prop_pair_up(index)

func item_down_presed(index : int) -> void:
	CustomRollManager.move_die_prop_pair_down(index)

func item_remove_pressed(index : int) -> void:
	CustomRollManager.remove_die_prop_pair_from_index(index)

func item_properties_changed(index : int, die_prop_pair : DiePropertyPair) -> void:
	CustomRollManager.update_die_prop_pair_at_index(index, die_prop_pair)

# When the add button is pressed, open a dialog to add a new die
func _on_add_button_pressed() -> void:
	die_selector_popup.configure_buttons()
	die_selector_popup.modular_popup(add_button.global_position)

func _on_save_button_pressed() -> void:
	pass # Replace with function body.

func _on_roll_button_pressed() -> void:
	var die_prop_pairs : Array[DiePropertyPair] = CustomRollManager.get_die_prop_pairs()
	if die_prop_pairs.size() == 0:
		return
	RollManager.custom_roll(CustomRollManager.get_die_prop_pairs())
