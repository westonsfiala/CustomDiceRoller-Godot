extends Control

@onready var dice_result : SettingsManagedRichTextLabel = $VerticalLayout/RichTextDiceResult
@onready var dice_grid : HFlowContainer = $VerticalLayout/ScrollContainer/DiceGrid
@onready var no_dice_label : Label = $NoDiceLabel
@onready var num_dice_buttons : UpDownButtons = $VerticalLayout/PropBar/UpDownButtonBar/NumDiceUpDown
@onready var modifier_buttons : UpDownButtons = $VerticalLayout/PropBar/UpDownButtonBar/ModifierUpDown
@onready var property_button : PropertyButton = $VerticalLayout/PropBar/PropertyButtonBar/PropertyButton
@onready var set_value_exact_popup : SetValueExactPopup = $SetValueExactPopup

var currently_edited_property_identifier : StringName = ""

# Connect to the settings manager and setup the scene with all of our dice
func _ready():
	RollManager.new_roll_result.connect(set_dice_result)
	SettingsManager.reconfigure.connect(deferred_reconfigure)
	SimpleRollManager.roll_properties_updated.connect(properties_updated)
	dice_updated()
	properties_updated()
	deferred_reconfigure()

func deferred_reconfigure():
	call_deferred("reconfigure")

# Remove all of our currently set diced and place new ones
func reconfigure():
	print("reconfiguring simple roll")
	custom_minimum_size.x = SettingsManager.get_window_size().x
	
func dice_updated() -> void:
	SettingsManager.remove_and_free_children(dice_grid)
	for die in SettingsManager.get_dice():
		var dice_node = preload("res://Scenes/Common/Buttons/clickable_die.tscn").instantiate()
		dice_grid.add_child(dice_node)
		dice_node.die_pressed.connect(roll_die)
		dice_node.configure(die)
	refresh_no_dice()

func properties_updated() -> void:
	var roll_properties = SimpleRollManager.get_roll_properties()
	num_dice_buttons.set_value(roll_properties.get_num_dice())
	modifier_buttons.set_value(roll_properties.get_modifier())
	property_button.set_properties(roll_properties)

# Roll the die that was clicked and set the results
func roll_die(die: AbstractDie):
	RollManager.simple_roll(die, SimpleRollManager.get_roll_properties())

# Displays the dice results
func set_dice_result(roll_result: RollResults):
	dice_result.visible = true
	dice_result.clear()
	dice_result.push_paragraph(HORIZONTAL_ALIGNMENT_CENTER)
	dice_result.append_text(roll_result.roll_sum.formatted_text)
	dice_result.pop()
	
func refresh_no_dice():
	var dice = SettingsManager.get_dice()
	if dice.is_empty():
		no_dice_label.visible = true
	else:
		no_dice_label.visible = false

func _on_property_button_properties_updated(roll_properties):
	SimpleRollManager.set_roll_properties(roll_properties)

func _on_property_button_reset_properties():
	SimpleRollManager.reset_properties()

func _on_num_dice_up_down_value_changed(value):
	var roll_properties : RollProperties = SimpleRollManager.get_roll_properties()
	roll_properties.set_num_dice(value)
	SimpleRollManager.set_roll_properties(roll_properties)

func _on_num_dice_up_down_value_pressed():
	up_down_pressed(RollProperties.NUM_DICE_IDENTIFIER)

func _on_modifier_up_down_value_changed(value):
	var roll_properties : RollProperties = SimpleRollManager.get_roll_properties()
	roll_properties.set_modifier(value)
	SimpleRollManager.set_roll_properties(roll_properties)

func _on_modifier_up_down_value_pressed():
	up_down_pressed(RollProperties.DICE_MODIFIER_IDENTIFIER)

func up_down_pressed(property_identifier: StringName):
	currently_edited_property_identifier = property_identifier
	var roll_properties : RollProperties = SimpleRollManager.get_roll_properties()
	match property_identifier:
		RollProperties.NUM_DICE_IDENTIFIER:
			set_value_exact_popup.set_initial_value(roll_properties.NUM_DICE_DISPLAY_TITLE, roll_properties.get_num_dice())
			set_value_exact_popup.modular_popup_center()
		RollProperties.DICE_MODIFIER_IDENTIFIER:
			set_value_exact_popup.set_initial_value(roll_properties.DICE_MODIFIER_DISPLAY_TITLE, roll_properties.get_modifier())
			set_value_exact_popup.modular_popup_center()

func _on_set_value_exact_popup_value_changed(value: int):
	var roll_properties : RollProperties = SimpleRollManager.get_roll_properties()
	match currently_edited_property_identifier:
		RollProperties.NUM_DICE_IDENTIFIER:
			roll_properties.set_num_dice(value)
			SimpleRollManager.set_roll_properties(roll_properties)
		RollProperties.DICE_MODIFIER_IDENTIFIER:
			roll_properties.set_modifier(value)
			SimpleRollManager.set_roll_properties(roll_properties)
