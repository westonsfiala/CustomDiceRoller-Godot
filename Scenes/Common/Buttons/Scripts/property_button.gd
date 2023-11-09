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

func _on_reset_button_pressed():
	emit_signal("reset_properties")

func _on_property_button_pressed():
	properties_popup.popup(Rect2i(get_screen_position(),Vector2i.ZERO))
