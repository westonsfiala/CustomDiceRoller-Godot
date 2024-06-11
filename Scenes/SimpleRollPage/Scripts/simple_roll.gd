extends Control
class_name SimpleRoll

@onready var dice_grid : HFlowContainer = $VerticalLayout/ScrollContainer/DiceGrid
@onready var no_dice_label : Label = $NoDiceLabel
@onready var num_dice_buttons : UpDownButtons = $VerticalLayout/PropBar/UpDownButtonBar/NumDiceUpDownButtons
@onready var modifier_buttons : UpDownButtons = $VerticalLayout/PropBar/UpDownButtonBar/ModifierUpDownButtons
@onready var property_button : PropertyButton = $VerticalLayout/PropBar/PropertyButtonBar/PropertyButton
@onready var min_max_edit_die_popup : MinMaxDieDialog = $MinMaxDieDialog
@onready var imbalanced_edit_die_popup : ImbalancedDieDialog = $ImbalancedDieDialog
@onready var word_edit_die_popup : WordDieDialog = $WordDieDialog

var currently_edited_property_identifier : StringName = ""

# Connect to the settings manager and setup the scene with all of our dice
func _ready() -> void:
	SettingsManager.window_size_changed.connect(reconfigure)
	SimpleRollManager.roll_properties_updated.connect(properties_updated)
	SimpleRollManager.simple_dice_updated.connect(dice_updated)
	dice_updated()
	properties_updated()
	reconfigure()

# Remove all of our currently set diced and place new ones
func reconfigure() -> void:
	custom_minimum_size.x = SettingsManager.get_window_size().x
	
func dice_updated() -> void:
	SettingsManager.remove_and_free_children(dice_grid)
	for die : AbstractDie in SimpleRollManager.get_dice():
		var dice_node : ClickableDie = preload("res://Scenes/Common/Buttons/clickable_die.tscn").instantiate()
		dice_grid.add_child(dice_node)
		dice_node.die_pressed.connect(roll_die)
		dice_node.die_long_pressed.connect(edit_die)
		dice_node.configure(die)
	refresh_no_dice()

func properties_updated() -> void:
	var roll_properties : RollProperties = SimpleRollManager.get_roll_properties()
	num_dice_buttons.set_value(roll_properties.get_num_dice())
	modifier_buttons.set_value(roll_properties.get_modifier())
	property_button.set_properties(roll_properties)

# Roll the die that was clicked and set the results
func roll_die(die: AbstractDie) -> void:
	RollManager.simple_roll(die, SimpleRollManager.get_roll_properties())
	
# Opens a dialog to edit the die
func edit_die(die: AbstractDie) -> void:
	match die.get_class_name():
		MinMaxDie.CLASS_NAME:
			min_max_edit_die_popup.set_min_max_die(die.duplicate())
			min_max_edit_die_popup.set_remove_button_visibility(true)
			min_max_edit_die_popup.modular_popup_center()
		ImbalancedDie.CLASS_NAME:
			imbalanced_edit_die_popup.set_imbalanced_die(die.duplicate())
			imbalanced_edit_die_popup.set_remove_button_visibility(true)
			imbalanced_edit_die_popup.modular_popup_center()
		WordDie.CLASS_NAME:
			word_edit_die_popup.set_word_die(die.duplicate())
			word_edit_die_popup.set_remove_button_visibility(true)
			word_edit_die_popup.modular_popup_center()
	
func refresh_no_dice() -> void:
	var dice : Array[AbstractDie] = SimpleRollManager.get_dice()
	if dice.is_empty():
		no_dice_label.visible = true
	else:
		no_dice_label.visible = false

func _on_property_button_properties_updated(roll_properties : RollProperties) -> void:
	SimpleRollManager.set_roll_properties(roll_properties)

func _on_property_button_reset_properties() -> void:
	SimpleRollManager.reset_properties()

func _on_num_dice_up_down_value_changed(value: int) -> void:
	var roll_properties : RollProperties = SimpleRollManager.get_roll_properties()
	roll_properties.set_num_dice(value)
	SimpleRollManager.set_roll_properties(roll_properties)

func _on_modifier_up_down_value_changed(value : int) -> void:
	var roll_properties : RollProperties = SimpleRollManager.get_roll_properties()
	roll_properties.set_modifier(value)
	SimpleRollManager.set_roll_properties(roll_properties)

func _on_add_dice_button_die_accepted(die: AbstractDie) -> void:
	SimpleRollManager.add_die(die)

func _on_add_dice_button_reset_dice() -> void:
	SimpleRollManager.reset_dice()

func _on_min_max_die_dialog_die_accepted(original_die: MinMaxDie, accepted_die: MinMaxDie) -> void:
	SimpleRollManager.edit_die(original_die, accepted_die)

func _on_min_max_die_dialog_die_removed(removed_die: MinMaxDie) -> void:
	SimpleRollManager.remove_die(removed_die)

func _on_imbalanced_die_dialog_die_accepted(original_die: ImbalancedDie, accepted_die: ImbalancedDie) -> void:
	SimpleRollManager.edit_die(original_die, accepted_die)

func _on_imbalanced_die_dialog_die_removed(removed_die: ImbalancedDie) -> void:
	SimpleRollManager.remove_die(removed_die)

func _on_word_die_dialog_die_accepted(original_die: WordDie, accepted_die: WordDie) -> void:
	SimpleRollManager.edit_die(original_die, accepted_die)

func _on_word_die_dialog_die_removed(removed_die: WordDie) -> void:
	SimpleRollManager.remove_die(removed_die)
