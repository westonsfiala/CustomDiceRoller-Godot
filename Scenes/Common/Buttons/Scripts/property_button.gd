extends Control
class_name PropertyButton

@onready var reset_button_margins : MarginContainer = $HBoxContainer/ResetMargins
@onready var reset_button : LongPressButton = $HBoxContainer/ResetMargins/ResetButton
@onready var property_button : SettingsManagedTextButton = $HBoxContainer/PropertyMargins/PropertyButton
@onready var change_properties_popup : ChangePropertiesPopup = $ChangePropertiesPopup
@onready var set_value_exact_popup : SetValueExactPopup = $SetValueExactPopup

var roll_properties : RollProperties = RollProperties.new()

var currently_edited_property_identifier : StringName = ""

const NO_PROP_STRING : StringName = "No Props"
const SINGLE_PROP_STRING : StringName = " Prop"
const MULTIPLE_PROP_STRING : StringName = " Props"

enum {
	RESET = 100,
	REPEAT,
	ADVANTAGE,
	DISADVANTAGE,
	DOUBLE,
	HALVE,
	NUM_DICE,
	MODIFIER,
	DROP_HIGH,
	DROP_LOW,
	KEEP_HIGH,
	KEEP_LOW,
	REROLL_OVER,
	REROLL_UNDER,
	MAXIMUM,
	MINIMUM,
	COUNT_ABOVE,
	COUNT_BELOW,
	EXPLODE
}

signal properties_updated(roll_properties: RollProperties)
signal reset_properties()

# Called when the node enters the scene tree for the first time.
func _ready():
	SettingsManager.reconfigure.connect(deferred_reconfigure)
	change_properties_popup.reset_pressed.connect(_on_reset_button_pressed)
	change_properties_popup.property_pressed.connect(popup_property_pressed)
	change_properties_popup.properties_updated.connect(popup_properties_updated)
	set_value_exact_popup.value_changed.connect(property_set_exact)
	
	deferred_reconfigure()
	
func deferred_reconfigure():
	call_deferred("reconfigure")

func reconfigure():
	var button_size = SettingsManager.get_button_size()
	var margin_size = reset_button_margins.get_theme_constant("margin_top") + reset_button_margins.get_theme_constant("margin_bottom")
	custom_minimum_size = Vector2(0, button_size + margin_size)
	
func set_properties(props: RollProperties) -> void:
	roll_properties = props
	change_properties_popup.set_properties(roll_properties)
	
	if(roll_properties.is_default()):
		reset_button_margins.visible = false
		property_button.text = NO_PROP_STRING
	else:
		reset_button_margins.visible = true
		var num_non_default = roll_properties.get_num_non_default()
		if(num_non_default == 1):
			property_button.text = str(num_non_default, SINGLE_PROP_STRING)
		else:
			property_button.text = str(num_non_default, MULTIPLE_PROP_STRING)
			
func popup_property_pressed(property_identifier: StringName):
	currently_edited_property_identifier = property_identifier
	match property_identifier:
		RollProperties.REPEAT_ROLL_IDENTIFIER:
			set_value_exact_popup.set_initial_value(roll_properties.REPEAT_ROLL_DISPLAY_TITLE, roll_properties.get_repeat_roll())
			set_value_exact_popup.modular_popup_center()
		RollProperties.ADVANTAGE_IDENTIFIER:
			roll_properties.toggle_advantage()
			emit_signal("properties_updated", roll_properties)
		RollProperties.DISADVANTAGE_IDENTIFIER:
			roll_properties.toggle_disadvantage()
			emit_signal("properties_updated", roll_properties)
		RollProperties.DOUBLE_IDENTIFIER:
			roll_properties.toggle_double()
			emit_signal("properties_updated", roll_properties)
		RollProperties.HALVE_IDENTIFIER:
			roll_properties.toggle_halve()
			emit_signal("properties_updated", roll_properties)
		RollProperties.NUM_DICE_IDENTIFIER:
			set_value_exact_popup.set_initial_value(roll_properties.NUM_DICE_DISPLAY_TITLE, roll_properties.get_num_dice())
			set_value_exact_popup.modular_popup_center()
		RollProperties.DICE_MODIFIER_IDENTIFIER:
			set_value_exact_popup.set_initial_value(roll_properties.DICE_MODIFIER_DISPLAY_TITLE, roll_properties.get_modifier())
			set_value_exact_popup.modular_popup_center()
		RollProperties.DROP_HIGHEST_IDENTIFIER:
			set_value_exact_popup.set_initial_value(roll_properties.DROP_HIGHEST_DISPLAY_TITLE, roll_properties.get_drop_highest())
			set_value_exact_popup.modular_popup_center()
		RollProperties.DROP_LOWEST_IDENTIFIER:
			set_value_exact_popup.set_initial_value(roll_properties.DROP_LOWEST_DISPLAY_TITLE, roll_properties.get_drop_lowest())
			set_value_exact_popup.modular_popup_center()
		RollProperties.KEEP_HIGHEST_IDENTIFIER:
			set_value_exact_popup.set_initial_value(roll_properties.KEEP_HIGHEST_DISPLAY_TITLE, roll_properties.get_keep_highest())
			set_value_exact_popup.modular_popup_center()
		RollProperties.KEEP_LOWEST_IDENTIFIER:
			set_value_exact_popup.set_initial_value(roll_properties.KEEP_LOWEST_DISPLAY_TITLE, roll_properties.get_keep_lowest())
			set_value_exact_popup.modular_popup_center()
		RollProperties.REROLL_OVER_IDENTIFIER:
			set_value_exact_popup.set_initial_value(roll_properties.REROLL_OVER_DISPLAY_TITLE, roll_properties.get_reroll_over())
			set_value_exact_popup.modular_popup_center()
		RollProperties.REROLL_UNDER_IDENTIFIER:
			set_value_exact_popup.set_initial_value(roll_properties.REROLL_UNDER_DISPLAY_TITLE, roll_properties.get_reroll_under())
			set_value_exact_popup.modular_popup_center()
		RollProperties.MAXIMUM_ROLL_VALUE_IDENTIFIER:
			set_value_exact_popup.set_initial_value(roll_properties.MAXIMUM_ROLL_VALUE_DISPLAY_TITLE, roll_properties.get_maximum())
			set_value_exact_popup.modular_popup_center()
		RollProperties.MINIMUM_ROLL_VALUE_IDENTIFIER:
			set_value_exact_popup.set_initial_value(roll_properties.MINIMUM_ROLL_VALUE_DISPLAY_TITLE, roll_properties.get_minimum())
			set_value_exact_popup.modular_popup_center()
		RollProperties.COUNT_ABOVE_EQUAL_IDENTIFIER:
			set_value_exact_popup.set_initial_value(roll_properties.COUNT_ABOVE_EQUAL_DISPLAY_TITLE, roll_properties.get_count_above())
			set_value_exact_popup.modular_popup_center()
		RollProperties.COUNT_BELOW_EQUAL_IDENTIFIER:
			set_value_exact_popup.set_initial_value(roll_properties.COUNT_BELOW_EQUAL_DISPLAY_TITLE, roll_properties.get_count_below())
			set_value_exact_popup.modular_popup_center()
		RollProperties.EXPLODE_IDENTIFIER:
			roll_properties.toggle_explode()
			emit_signal("properties_updated", roll_properties)
			
func property_set_exact(value: int) -> void:
	match currently_edited_property_identifier:
		RollProperties.REPEAT_ROLL_IDENTIFIER:
			roll_properties.set_repeat_roll(value)
			emit_signal("properties_updated", roll_properties)
		RollProperties.ADVANTAGE_IDENTIFIER:
			pass # No set exact
		RollProperties.DISADVANTAGE_IDENTIFIER:
			pass # No set exact
		RollProperties.DOUBLE_IDENTIFIER:
			pass # No set exact
		RollProperties.HALVE_IDENTIFIER:
			pass # No set exact
		RollProperties.NUM_DICE_IDENTIFIER:
			roll_properties.set_num_dice(value)
			emit_signal("properties_updated", roll_properties)
		RollProperties.DICE_MODIFIER_IDENTIFIER:
			roll_properties.set_modifier(value)
			emit_signal("properties_updated", roll_properties)
		RollProperties.DROP_HIGHEST_IDENTIFIER:
			roll_properties.set_drop_highest(value)
			emit_signal("properties_updated", roll_properties)
		RollProperties.DROP_LOWEST_IDENTIFIER:
			roll_properties.set_drop_lowest(value)
			emit_signal("properties_updated", roll_properties)
		RollProperties.KEEP_HIGHEST_IDENTIFIER:
			roll_properties.set_keep_highest(value)
			emit_signal("properties_updated", roll_properties)
		RollProperties.KEEP_LOWEST_IDENTIFIER:
			roll_properties.set_keep_lowest(value)
			emit_signal("properties_updated", roll_properties)
		RollProperties.REROLL_OVER_IDENTIFIER:
			roll_properties.set_reroll_over(value)
			emit_signal("properties_updated", roll_properties)
		RollProperties.REROLL_UNDER_IDENTIFIER:
			roll_properties.set_reroll_under(value)
			emit_signal("properties_updated", roll_properties)
		RollProperties.MAXIMUM_ROLL_VALUE_IDENTIFIER:
			roll_properties.set_maximum(value)
			emit_signal("properties_updated", roll_properties)
		RollProperties.MINIMUM_ROLL_VALUE_IDENTIFIER:
			roll_properties.set_minimum(value)
			emit_signal("properties_updated", roll_properties)
		RollProperties.COUNT_ABOVE_EQUAL_IDENTIFIER:
			roll_properties.set_count_above(value)
			emit_signal("properties_updated", roll_properties)
		RollProperties.COUNT_BELOW_EQUAL_IDENTIFIER:
			roll_properties.set_count_below(value)
			emit_signal("properties_updated", roll_properties)
		RollProperties.EXPLODE_IDENTIFIER:
			pass # No set exact
			
func popup_properties_updated(properties: RollProperties) -> void:
	roll_properties = properties
	emit_signal("properties_updated", roll_properties)
	
func _on_reset_button_pressed():
	emit_signal("reset_properties")

func _on_property_button_pressed():
	change_properties_popup.modular_popup(get_screen_position())
	
