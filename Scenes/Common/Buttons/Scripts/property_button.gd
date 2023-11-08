extends Control
class_name PropertyButton

@onready var reset_button_margins : MarginContainer = $HBoxContainer/ResetMargins
@onready var reset_button : LongPressButton = $HBoxContainer/ResetMargins/ResetButton
@onready var property_button : SettingsManagedTextButton = $HBoxContainer/PropertyMargins/PropertyButton
@onready var properties_selector_popup : PopupMenu = $PropertiesSelectorPopup

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
	properties_selector_popup.clear()
	
	# Reset at the top
	properties_selector_popup.add_item("Reset Properties", RESET)
	properties_selector_popup.add_separator()
	
	# Repeat
	var repeat_string = roll_properties.get_repeat_roll_string()
	if(roll_properties.has_repeat_roll()):
		repeat_string += "*"
	properties_selector_popup.add_item(repeat_string, REPEAT)
	properties_selector_popup.add_separator()
	
	# Advantage/Disadvantage
	var advantage_string : String = roll_properties.ADVANTAGE_TITLE
	var advantage_checked = false
	if(roll_properties.is_advantage()):
		advantage_string += "*"
		advantage_checked = true
	properties_selector_popup.add_check_item(advantage_string, ADVANTAGE)
	properties_selector_popup.set_item_checked(properties_selector_popup.get_item_index(ADVANTAGE), advantage_checked)
	
	var disadvantage_string : String = roll_properties.DISADVANTAGE_TITLE
	var disadvantage_checked = false
	if(roll_properties.is_disadvantage()):
		disadvantage_string += "*"
		disadvantage_checked = true
	properties_selector_popup.add_check_item(disadvantage_string, DISADVANTAGE)
	properties_selector_popup.set_item_checked(properties_selector_popup.get_item_index(DISADVANTAGE), disadvantage_checked)
	properties_selector_popup.add_separator()
	
	# Double/Halve
	var double_string : String = roll_properties.DOUBLE_TITLE
	var double_checked = false
	if(roll_properties.is_double()):
		double_string += "*"
		double_checked = true
	properties_selector_popup.add_check_item(double_string, DOUBLE)
	properties_selector_popup.set_item_checked(properties_selector_popup.get_item_index(DOUBLE), double_checked)
	
	var halve_string : String = roll_properties.HALVE_TITLE
	var halve_checked = false
	if(roll_properties.is_halve()):
		halve_string += "*"
		halve_checked = true
	properties_selector_popup.add_check_item(halve_string, HALVE)
	properties_selector_popup.set_item_checked(properties_selector_popup.get_item_index(HALVE), halve_checked)
	properties_selector_popup.add_separator()
	
	# Num Dice/Modifier
	var num_dice_string : String = roll_properties.get_num_dice_long_string()
	if(roll_properties.has_num_dice()):
		num_dice_string += "*"
	properties_selector_popup.add_item(num_dice_string, NUM_DICE)
	
	var modifier_string : String = roll_properties.get_modifier_string()
	if(roll_properties.has_modifier()):
		modifier_string += "*"
	properties_selector_popup.add_item(modifier_string, MODIFIER)
	properties_selector_popup.add_separator()
	
	# Drop High/Low
	var drop_highest_string : String = roll_properties.get_drop_highest_string()
	if(roll_properties.has_drop_highest()):
		drop_highest_string += "*"
	properties_selector_popup.add_item(drop_highest_string, DROP_HIGH)
	
	var drop_lowest_string : String = roll_properties.get_drop_lowest_string()
	if(roll_properties.has_drop_lowest()):
		drop_lowest_string += "*"
	properties_selector_popup.add_item(drop_lowest_string, DROP_LOW)
	properties_selector_popup.add_separator()
	
	# Keep High/Low
	var keep_highest_string : String = roll_properties.get_keep_highest_string()
	if(roll_properties.has_keep_highest()):
		keep_highest_string += "*"
	properties_selector_popup.add_item(keep_highest_string, KEEP_HIGH)
	
	var keep_lowest_string : String = roll_properties.get_keep_lowest_string()
	if(roll_properties.has_keep_lowest()):
		keep_lowest_string += "*"
	properties_selector_popup.add_item(keep_lowest_string, KEEP_LOW)
	properties_selector_popup.add_separator()
	
	# Reroll Over/Under
	var reroll_over_string : String = roll_properties.get_reroll_over_string()
	if(roll_properties.has_keep_highest()):
		reroll_over_string += "*"
	properties_selector_popup.add_item(reroll_over_string, REROLL_OVER)
	
	var reroll_under_string : String = roll_properties.get_reroll_under_string()
	if(roll_properties.has_reroll_under()):
		reroll_under_string += "*"
	properties_selector_popup.add_item(reroll_under_string, REROLL_UNDER)
	properties_selector_popup.add_separator()
	
	# Maximum/Minimum
	var maximum_string : String = roll_properties.get_maximum_string()
	if(roll_properties.has_maximum()):
		maximum_string += "*"
	properties_selector_popup.add_item(maximum_string, MAXIMUM)
	
	var minimum_string : String = roll_properties.get_minimum_string()
	if(roll_properties.has_minimum()):
		minimum_string += "*"
	properties_selector_popup.add_item(minimum_string, MINIMUM)
	properties_selector_popup.add_separator()
	
	# Count Above/Below
	var count_above_string : String = roll_properties.get_count_above_string()
	if(roll_properties.has_count_above()):
		count_above_string += "*"
	properties_selector_popup.add_item(count_above_string, COUNT_ABOVE)
	
	var count_below_string : String = roll_properties.get_count_below_string()
	if(roll_properties.has_minimum()):
		count_below_string += "*"
	properties_selector_popup.add_item(count_below_string, COUNT_BELOW)
	properties_selector_popup.add_separator()
	
	# Advantage/Disadvantage
	var explode_string : String = roll_properties.EXPLODE_TITLE
	var explode_checked = false
	if(roll_properties.has_explode()):
		explode_string += "*"
		explode_checked = true
	properties_selector_popup.add_check_item(explode_string, EXPLODE)
	properties_selector_popup.set_item_checked(properties_selector_popup.get_item_index(EXPLODE), explode_checked)
	
	properties_selector_popup.popup(Rect2i(property_button.get_screen_position(), Vector2i.ZERO))
	
func _on_properties_selector_popup_id_pressed(id):
	print(str('ID pressed = ', id))
	













