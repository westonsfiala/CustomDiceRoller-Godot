extends Control
class_name PropertyButton

@onready var reset_button_margins : MarginContainer = $HBoxContainer/ResetMargins
@onready var reset_button : LongPressButton = $HBoxContainer/ResetMargins/ResetButton
@onready var property_button : SettingsManagedTextButton = $HBoxContainer/PropertyMargins/PropertyButton
@onready var properties_popup : PropertiesPopup = $PropertiesPopup

var roll_properties : RollProperties = RollProperties.new()

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
	properties_popup.reset_pressed.connect(_on_reset_button_pressed)
	properties_popup.property_pressed.connect(popup_property_pressed)
	properties_popup.properties_updated.connect(popup_properties_updated)
	
	deferred_reconfigure()
	
func deferred_reconfigure():
	call_deferred("reconfigure")

func reconfigure():
	print("reconfiguring property buttons")
	var button_size = SettingsManager.get_button_size()
	var margin_size = reset_button_margins.get_theme_constant("margin_top") + reset_button_margins.get_theme_constant("margin_bottom")
	custom_minimum_size = Vector2(0, button_size + margin_size)
	
func set_properties(props: RollProperties) -> void:
	roll_properties = props
	properties_popup.set_properties(roll_properties)
	
	if(roll_properties.is_default()):
		reset_button_margins.visible = false
		property_button.change_text(NO_PROP_STRING)
	else:
		reset_button_margins.visible = true
		var num_non_default = roll_properties.get_num_non_default()
		if(num_non_default == 1):
			property_button.change_text(str(num_non_default, SINGLE_PROP_STRING))
		else:
			property_button.change_text(str(num_non_default, MULTIPLE_PROP_STRING))
			
func popup_property_pressed(property_identifier: StringName):
	print(property_identifier)
	match property_identifier:
		RollProperties.REPEAT_ROLL_IDENTIFIER:
			pass
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
			pass
		RollProperties.DICE_MODIFIER_IDENTIFIER:
			pass
		RollProperties.DROP_HIGHEST_IDENTIFIER:
			pass
		RollProperties.DROP_LOWEST_IDENTIFIER:
			pass
		RollProperties.KEEP_HIGHEST_IDENTIFIER:
			pass
		RollProperties.KEEP_LOWEST_IDENTIFIER:
			pass
		RollProperties.REROLL_OVER_IDENTIFIER:
			pass
		RollProperties.REROLL_UNDER_IDENTIFIER:
			pass
		RollProperties.MAXIMUM_ROLL_VALUE_IDENTIFIER:
			pass
		RollProperties.MINIMUM_ROLL_VALUE_IDENTIFIER:
			pass
		RollProperties.COUNT_ABOVE_EQUAL_IDENTIFIER:
			pass
		RollProperties.COUNT_BELOW_EQUAL_IDENTIFIER:
			pass
		RollProperties.EXPLODE_IDENTIFIER:
			roll_properties.toggle_explode()
			emit_signal("properties_updated", roll_properties)
			
func popup_properties_updated(properties: RollProperties) -> void:
	roll_properties = properties
	emit_signal("properties_updated", roll_properties)
	
func _on_reset_button_pressed():
	emit_signal("reset_properties")

func _on_property_button_pressed():
	properties_popup.modular_popup(get_screen_position())
	
