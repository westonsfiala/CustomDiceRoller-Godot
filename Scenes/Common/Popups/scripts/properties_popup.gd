extends Popup
class_name PropertiesPopup

@onready var color_rect : ColorRect = $ColorRect

@onready var reset_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/ResetProp
@onready var num_dice_updown : UpDownButtons = $ColorRect/PropertiesScroller/PropertiesLayout/NumDiceUpDown
@onready var modifier_updown : UpDownButtons = $ColorRect/PropertiesScroller/PropertiesLayout/ModifierUpDown
@onready var repeat_updown : UpDownButtons = $ColorRect/PropertiesScroller/PropertiesLayout/RepeatUpDown
@onready var advantage_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/AdvantageProp
@onready var disadvantage_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/DisadvantageProp
@onready var double_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/DoubleProp
@onready var halve_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/HalveProp
@onready var drop_highest_updown : UpDownButtons = $ColorRect/PropertiesScroller/PropertiesLayout/DropHighUpDown
@onready var drop_lowest_updown : UpDownButtons = $ColorRect/PropertiesScroller/PropertiesLayout/DropLowUpDown
@onready var keep_highest_updown : UpDownButtons = $ColorRect/PropertiesScroller/PropertiesLayout/KeepHighUpDown
@onready var keep_lowest_updown : UpDownButtons = $ColorRect/PropertiesScroller/PropertiesLayout/KeepLowUpDown
@onready var reroll_over_updown : UpDownButtons = $ColorRect/PropertiesScroller/PropertiesLayout/RerollOverUpDown
@onready var reroll_under_updown : UpDownButtons = $ColorRect/PropertiesScroller/PropertiesLayout/RerollUnderUpDown
@onready var count_above_updown : UpDownButtons = $ColorRect/PropertiesScroller/PropertiesLayout/CountAboveUpDown
@onready var count_below_updown : UpDownButtons = $ColorRect/PropertiesScroller/PropertiesLayout/CountBelowUpDown
@onready var maximum_updown : UpDownButtons = $ColorRect/PropertiesScroller/PropertiesLayout/MaximumUpDown
@onready var minimum_updown : UpDownButtons = $ColorRect/PropertiesScroller/PropertiesLayout/MinimumUpDown
@onready var explode_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/ExplodeProp

@onready var animation_player : AnimationPlayer = $AnimationPlayer

signal reset_pressed()
signal property_pressed(property_identifier : StringName)
signal properties_updated(roll_properties: RollProperties)

const APPEND_ASTERISK : StringName = " *"

var roll_properties : RollProperties = RollProperties.new()

func _ready():
	SettingsManager.reconfigure.connect(reconfigure)
	deferred_reconfigure()
	
func deferred_reconfigure():
	call_deferred("reconfigure")

# Reconfigures the scene according to the settings
func reconfigure():
	print("reconfiguring properties popup")
	var three_fourths_window_size = SettingsManager.get_window_size() * 3 / 4
	var property_heights = RollProperties.PROPERTY_DEFAULT_MAP.size() * SettingsManager.get_button_size()
	var property_widths = SettingsManager.get_button_size() * 9 # Its a rough estimate of how big stuff is.
	var min_height = min(three_fourths_window_size.y, property_heights)
	var min_width = min(three_fourths_window_size.x, property_widths)
	
	var popup_size = Vector2i(min_width, min_height)
	size = popup_size
	color_rect.custom_minimum_size = popup_size
	color_rect.pivot_offset = popup_size / 2
	
# Set the properties and set button text accordingly
func set_properties(props: RollProperties) -> void:
	roll_properties = props
	refresh_text()

func _on_about_to_popup():
	animation_player.play("popup")
	
func refresh_text() -> void:
	# Reset at the top
	reset_button.change_text("Reset Properties")
	
	# Num Dice/Modifier
	var num_dice_postfix = RollProperties.NUM_DICE_TITLE_POSTFIX
	if(roll_properties.has_num_dice()):
		num_dice_postfix += APPEND_ASTERISK
	
	num_dice_updown.setup_exports(RollProperties.NUM_DICE_TITLE_PREFIX, num_dice_postfix, false, true)
	num_dice_updown.set_value(roll_properties.get_num_dice())
	
	var modifier_postfix = RollProperties.DICE_MODIFIER_TITLE_POSTFIX
	if(roll_properties.has_modifier()):
		modifier_postfix += APPEND_ASTERISK
	
	modifier_updown.setup_exports(RollProperties.DICE_MODIFIER_TITLE_PREFIX, modifier_postfix, true, false)
	modifier_updown.set_value(roll_properties.get_modifier())
	
	# Repeat
	var repeat_postfix = RollProperties.REPEAT_ROLL_TITLE_POSTFIX
	if(roll_properties.has_repeat_roll()):
		repeat_postfix += APPEND_ASTERISK
	
	repeat_updown.setup_exports(RollProperties.REPEAT_ROLL_TITLE_PREFIX, repeat_postfix, false, true)
	repeat_updown.set_value(roll_properties.get_repeat_roll())
	
	# Advantage/Disadvantage
	var advantage_string : String = roll_properties.ADVANTAGE_TITLE
	advantage_button.icon = null
	if(roll_properties.is_advantage()):
		advantage_string += APPEND_ASTERISK
		advantage_button.icon = preload("res://Icons/check-mark.svg")
	advantage_button.change_text(advantage_string)
	
	var disadvantage_string : String = roll_properties.DISADVANTAGE_TITLE
	disadvantage_button.icon = null
	if(roll_properties.is_disadvantage()):
		disadvantage_string += APPEND_ASTERISK
		disadvantage_button.icon = preload("res://Icons/check-mark.svg")
	disadvantage_button.change_text(disadvantage_string)
	
	# Double/Halve
	var double_string : String = roll_properties.DOUBLE_TITLE
	double_button.icon = null
	if(roll_properties.is_double()):
		double_string += APPEND_ASTERISK
		double_button.icon = preload("res://Icons/check-mark.svg")
	double_button.change_text(double_string)
	
	var halve_string : String = roll_properties.HALVE_TITLE
	halve_button.icon = null
	if(roll_properties.is_halve()):
		halve_string += APPEND_ASTERISK
		halve_button.icon = preload("res://Icons/check-mark.svg")
	halve_button.change_text(halve_string)
	
	# Drop High/Low
	var drop_highest_postfix = RollProperties.DROP_HIGHEST_TITLE_POSTFIX
	if(roll_properties.has_drop_highest()):
		drop_highest_postfix += APPEND_ASTERISK
	
	drop_highest_updown.setup_exports(RollProperties.DROP_HIGHEST_TITLE_PREFIX, drop_highest_postfix, false, false)
	drop_highest_updown.set_value(roll_properties.get_drop_highest())
	
	var drop_lowest_postfix = RollProperties.DROP_LOWEST_TITLE_POSTFIX
	if(roll_properties.has_drop_lowest()):
		drop_lowest_postfix += APPEND_ASTERISK
	
	drop_lowest_updown.setup_exports(RollProperties.DROP_LOWEST_TITLE_PREFIX, drop_lowest_postfix, false, false)
	drop_lowest_updown.set_value(roll_properties.get_drop_lowest())
	
	# Keep High/Low
	var keep_highest_postfix = RollProperties.KEEP_HIGHEST_TITLE_POSTFIX
	if(roll_properties.has_keep_highest()):
		keep_highest_postfix += APPEND_ASTERISK
	
	keep_highest_updown.setup_exports(RollProperties.KEEP_HIGHEST_TITLE_PREFIX, keep_highest_postfix, false, false)
	keep_highest_updown.set_value(roll_properties.get_keep_highest())
	
	var keep_lowest_postfix = RollProperties.KEEP_LOWEST_TITLE_POSTFIX
	if(roll_properties.has_keep_lowest()):
		keep_lowest_postfix += APPEND_ASTERISK
	
	keep_lowest_updown.setup_exports(RollProperties.KEEP_LOWEST_TITLE_PREFIX, keep_lowest_postfix, false, false)
	keep_lowest_updown.set_value(roll_properties.get_keep_lowest())
	
	# Reroll Over/Under
	var reroll_over_postfix = RollProperties.REROLL_OVER_TITLE_POSTFIX
	if(roll_properties.has_reroll_over()):
		reroll_over_postfix += APPEND_ASTERISK
	
	reroll_over_updown.setup_exports(RollProperties.REROLL_OVER_TITLE_PREFIX, reroll_over_postfix, false, false)
	reroll_over_updown.set_value(roll_properties.get_reroll_over())
	
	var reroll_under_postfix = RollProperties.REROLL_UNDER_TITLE_POSTFIX
	if(roll_properties.has_reroll_under()):
		reroll_under_postfix += APPEND_ASTERISK
	
	reroll_under_updown.setup_exports(RollProperties.REROLL_UNDER_TITLE_PREFIX, reroll_under_postfix, false, false)
	reroll_under_updown.set_value(roll_properties.get_reroll_under())
	
	# Maximum/Minimum
	var maximum_postfix = RollProperties.MAXIMUM_ROLL_VALUE_TITLE_POSTFIX
	if(roll_properties.has_maximum()):
		maximum_postfix += APPEND_ASTERISK
	
	maximum_updown.setup_exports(RollProperties.MAXIMUM_ROLL_VALUE_TITLE_PREFIX, maximum_postfix, false, false)
	maximum_updown.set_value(roll_properties.get_maximum())
	
	var minimum_postfix = RollProperties.MINIMUM_ROLL_VALUE_TITLE_POSTFIX
	if(roll_properties.has_minimum()):
		minimum_postfix += APPEND_ASTERISK
	
	minimum_updown.setup_exports(RollProperties.MINIMUM_ROLL_VALUE_TITLE_PREFIX, minimum_postfix, false, false)
	minimum_updown.set_value(roll_properties.get_minimum())
	
	# Count Above/Below	
	var count_above_postfix = RollProperties.COUNT_ABOVE_EQUAL_TITLE_POSTFIX
	if(roll_properties.has_count_above()):
		count_above_postfix += APPEND_ASTERISK
	
	count_above_updown.setup_exports(RollProperties.COUNT_ABOVE_EQUAL_TITLE_PREFIX, count_above_postfix, false, false)
	count_above_updown.set_value(roll_properties.get_count_above())
	
	var count_below_postfix = RollProperties.COUNT_BELOW_EQUAL_TITLE_POSTFIX
	if(roll_properties.has_count_below()):
		count_below_postfix += APPEND_ASTERISK
	
	count_below_updown.setup_exports(RollProperties.COUNT_BELOW_EQUAL_TITLE_PREFIX, count_below_postfix, false, false)
	count_below_updown.set_value(roll_properties.get_count_below())
	
	# Explode
	var explode_string : String = roll_properties.EXPLODE_TITLE
	explode_button.icon = null
	if(roll_properties.get_explode()):
		explode_string += "*"
		explode_button.icon = preload("res://Icons/check-mark.svg")
	explode_button.change_text(explode_string)

func _on_reset_prop_pressed():
	emit_signal("reset_pressed")
	animation_player.play_backwards("popup")

func _on_repeat_up_down_value_changed(value):
	roll_properties.set_repeat_roll(value)
	emit_signal("properties_updated", roll_properties)

func _on_repeat_up_down_value_pressed():
	emit_signal("property_pressed", RollProperties.REPEAT_ROLL_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_advantage_prop_pressed():
	emit_signal("property_pressed", RollProperties.ADVANTAGE_IDENTIFIER)

func _on_disadvantage_prop_pressed():
	emit_signal("property_pressed", RollProperties.DISADVANTAGE_IDENTIFIER)

func _on_double_prop_pressed():
	emit_signal("property_pressed", RollProperties.DOUBLE_IDENTIFIER)

func _on_halve_prop_pressed():
	emit_signal("property_pressed", RollProperties.HALVE_IDENTIFIER)

func _on_num_dice_up_down_value_changed(value):
	roll_properties.set_num_dice(value)
	emit_signal("properties_updated", roll_properties)

func _on_num_dice_up_down_value_pressed():
	emit_signal("property_pressed", RollProperties.NUM_DICE_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_modifier_up_down_value_changed(value):
	roll_properties.set_modifier(value)
	emit_signal("properties_updated", roll_properties)

func _on_modifier_up_down_value_pressed():
	emit_signal("property_pressed", RollProperties.DICE_MODIFIER_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_drop_high_up_down_value_changed(value):
	roll_properties.set_drop_highest(value)
	emit_signal("properties_updated", roll_properties)

func _on_drop_high_up_down_value_pressed():
	emit_signal("property_pressed", RollProperties.DROP_HIGHEST_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_drop_low_up_down_value_changed(value):
	roll_properties.set_drop_lowest(value)
	emit_signal("properties_updated", roll_properties)

func _on_drop_low_up_down_value_pressed():
	emit_signal("property_pressed", RollProperties.DROP_LOWEST_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_keep_high_up_down_value_changed(value):
	roll_properties.set_keep_highest(value)
	emit_signal("properties_updated", roll_properties)

func _on_keep_high_up_down_value_pressed():
	emit_signal("property_pressed", RollProperties.KEEP_HIGHEST_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_keep_low_up_down_value_changed(value):
	roll_properties.set_keep_lowest(value)
	emit_signal("properties_updated", roll_properties)

func _on_keep_low_up_down_value_pressed():
	emit_signal("property_pressed", RollProperties.KEEP_LOWEST_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_reroll_over_up_down_value_changed(value):
	roll_properties.set_reroll_over(value)
	emit_signal("properties_updated", roll_properties)

func _on_reroll_over_up_down_value_pressed():
	emit_signal("property_pressed", RollProperties.REROLL_OVER_IDENTIFIER)
	animation_player.play_backwards("popup")
	
func _on_reroll_under_up_down_value_changed(value):
	roll_properties.set_reroll_under(value)
	emit_signal("properties_updated", roll_properties)

func _on_reroll_under_up_down_value_pressed():
	emit_signal("property_pressed", RollProperties.REROLL_UNDER_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_maximum_up_down_value_changed(value):
	roll_properties.set_maximum(value)
	emit_signal("properties_updated", roll_properties)

func _on_maximum_up_down_value_pressed():
	emit_signal("property_pressed", RollProperties.MAXIMUM_ROLL_VALUE_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_minimum_up_down_value_changed(value):
	roll_properties.set_minimum(value)
	emit_signal("properties_updated", roll_properties)

func _on_minimum_up_down_value_pressed():
	emit_signal("property_pressed", RollProperties.MINIMUM_ROLL_VALUE_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_count_above_up_down_value_changed(value):
	roll_properties.set_count_above(value)
	emit_signal("properties_updated", roll_properties)

func _on_count_above_up_down_value_pressed():
	emit_signal("property_pressed", RollProperties.COUNT_ABOVE_EQUAL_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_count_below_up_down_value_changed(value):
	roll_properties.set_count_below(value)
	emit_signal("properties_updated", roll_properties)

func _on_count_below_up_down_value_pressed():
	emit_signal("property_pressed", RollProperties.COUNT_BELOW_EQUAL_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_explode_prop_pressed():
	emit_signal("property_pressed", RollProperties.EXPLODE_IDENTIFIER)

