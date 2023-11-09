extends Popup
class_name PropertiesPopup

@onready var color_rect : ColorRect = $ColorRect

@onready var reset_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/ResetProp
@onready var repeat_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/RepeatProp
@onready var advantage_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/AdvantageProp
@onready var disadvantage_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/DisadvantageProp
@onready var double_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/DoubleProp
@onready var halve_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/HalveProp
@onready var num_dice_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/NumDiceProp
@onready var modifier_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/ModifierProp
@onready var drop_highest_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/DropHighProp
@onready var drop_lowest_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/DropLowProp
@onready var keep_highest_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/KeepHighProp
@onready var keep_lowest_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/KeepLowProp
@onready var reroll_over_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/RerollOverProp
@onready var reroll_under_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/RerollUnderProp
@onready var count_above_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/CountAboveProp
@onready var count_below_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/CountBelowProp
@onready var maximum_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/MaximumProp
@onready var minimum_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/MinimumProp
@onready var explode_button : SettingsManagedTextButton = $ColorRect/PropertiesScroller/PropertiesLayout/ExplodeProp

@onready var animation_player : AnimationPlayer = $AnimationPlayer

signal reset_pressed()
signal property_pressed(property_identifier : StringName)

var roll_properties : RollProperties = RollProperties.new()

func _ready():
	SettingsManager.reconfigure.connect(reconfigure)
	deferred_reconfigure()
	
func deferred_reconfigure():
	call_deferred("reconfigure")

# Reconfigures the scene according to the settings
func reconfigure():
	print("reconfiguring properties popup")
	var three_fourths_window_height = SettingsManager.get_window_size().y * 3 / 4
	var property_heights = RollProperties.PROPERTY_DEFAULT_MAP.size() * SettingsManager.get_button_size()
	var min_height = min(three_fourths_window_height, property_heights)
	
	var popup_size = Vector2i(350, min_height)
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
	
	# Repeat
	var repeat_string = roll_properties.get_repeat_roll_string()
	if(roll_properties.has_repeat_roll()):
		repeat_string += "*"
	repeat_button.change_text(repeat_string)
	
	# Advantage/Disadvantage
	var advantage_string : String = roll_properties.ADVANTAGE_TITLE
	advantage_button.icon = null
	if(roll_properties.is_advantage()):
		advantage_string += "*"
		advantage_button.icon = preload("res://Icons/check-mark.svg")
	advantage_button.change_text(advantage_string)
	
	var disadvantage_string : String = roll_properties.DISADVANTAGE_TITLE
	disadvantage_button.icon = null
	if(roll_properties.is_disadvantage()):
		disadvantage_string += "*"
		disadvantage_button.icon = preload("res://Icons/check-mark.svg")
	disadvantage_button.change_text(disadvantage_string)
	
	# Double/Halve
	var double_string : String = roll_properties.DOUBLE_TITLE
	double_button.icon = null
	if(roll_properties.is_double()):
		double_string += "*"
		double_button.icon = preload("res://Icons/check-mark.svg")
	double_button.change_text(double_string)
	
	var halve_string : String = roll_properties.HALVE_TITLE
	halve_button.icon = null
	if(roll_properties.is_halve()):
		halve_string += "*"
		halve_button.icon = preload("res://Icons/check-mark.svg")
	halve_button.change_text(halve_string)
	
	# Num Dice/Modifier
	var num_dice_string : String = roll_properties.get_num_dice_long_string()
	if(roll_properties.has_num_dice()):
		num_dice_string += "*"
	num_dice_button.change_text(num_dice_string)
	
	var modifier_string : String = roll_properties.get_modifier_string()
	if(roll_properties.has_modifier()):
		modifier_string += "*"
	modifier_button.change_text(modifier_string)
	
	# Drop High/Low
	var drop_highest_string : String = roll_properties.get_drop_highest_string()
	if(roll_properties.has_drop_highest()):
		drop_highest_string += "*"
	drop_highest_button.change_text(drop_highest_string)
	
	var drop_lowest_string : String = roll_properties.get_drop_lowest_string()
	if(roll_properties.has_drop_lowest()):
		drop_lowest_string += "*"
	drop_lowest_button.change_text(drop_lowest_string)
	
	# Keep High/Low
	var keep_highest_string : String = roll_properties.get_keep_highest_string()
	if(roll_properties.has_keep_highest()):
		keep_highest_string += "*"
	keep_highest_button.change_text(keep_highest_string)
	
	var keep_lowest_string : String = roll_properties.get_keep_lowest_string()
	if(roll_properties.has_keep_lowest()):
		keep_lowest_string += "*"
	keep_lowest_button.change_text(keep_lowest_string)
	
	# Reroll Over/Under
	var reroll_over_string : String = roll_properties.get_reroll_over_string()
	if(roll_properties.has_keep_highest()):
		reroll_over_string += "*"
	reroll_over_button.change_text(reroll_over_string)
	
	var reroll_under_string : String = roll_properties.get_reroll_under_string()
	if(roll_properties.has_reroll_under()):
		reroll_under_string += "*"
	reroll_under_button.change_text(reroll_under_string)
	
	# Maximum/Minimum
	var maximum_string : String = roll_properties.get_maximum_string()
	if(roll_properties.has_maximum()):
		maximum_string += "*"
	maximum_button.change_text(maximum_string)
	
	var minimum_string : String = roll_properties.get_minimum_string()
	if(roll_properties.has_minimum()):
		minimum_string += "*"
	minimum_button.change_text(minimum_string)
	
	# Count Above/Below
	var count_above_string : String = roll_properties.get_count_above_string()
	if(roll_properties.has_count_above()):
		count_above_string += "*"
	count_above_button.change_text(count_above_string)
	
	var count_below_string : String = roll_properties.get_count_below_string()
	if(roll_properties.has_minimum()):
		count_below_string += "*"
	count_below_button.change_text(count_below_string)
	
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

func _on_repeat_prop_pressed():
	emit_signal("property_pressed", RollProperties.REPEAT_ROLL_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_advantage_prop_pressed():
	emit_signal("property_pressed", RollProperties.ADVANTAGE_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_disadvantage_prop_pressed():
	emit_signal("property_pressed", RollProperties.DISADVANTAGE_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_double_prop_pressed():
	emit_signal("property_pressed", RollProperties.DOUBLE_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_halve_prop_pressed():
	emit_signal("property_pressed", RollProperties.HALVE_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_num_dice_prop_pressed():
	emit_signal("property_pressed", RollProperties.NUM_DICE_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_modifier_prop_pressed():
	emit_signal("property_pressed", RollProperties.DICE_MODIFIER_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_drop_high_prop_pressed():
	emit_signal("property_pressed", RollProperties.DROP_HIGHEST_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_drop_low_prop_pressed():
	emit_signal("property_pressed", RollProperties.DROP_LOWEST_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_keep_high_prop_pressed():
	emit_signal("property_pressed", RollProperties.KEEP_HIGHEST_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_keep_low_prop_pressed():
	emit_signal("property_pressed", RollProperties.KEEP_LOWEST_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_reroll_over_prop_pressed():
	emit_signal("property_pressed", RollProperties.REROLL_OVER_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_reroll_under_prop_pressed():
	emit_signal("property_pressed", RollProperties.REROLL_UNDER_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_maximum_prop_pressed():
	emit_signal("property_pressed", RollProperties.MAXIMUM_ROLL_VALUE_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_minimum_prop_pressed():
	emit_signal("property_pressed", RollProperties.MINIMUM_ROLL_VALUE_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_count_above_prop_pressed():
	emit_signal("property_pressed", RollProperties.COUNT_ABOVE_EQUAL_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_count_below_prop_pressed():
	emit_signal("property_pressed", RollProperties.COUNT_BELOW_EQUAL_IDENTIFIER)
	animation_player.play_backwards("popup")

func _on_explode_prop_pressed():
	emit_signal("property_pressed", RollProperties.EXPLODE_IDENTIFIER)
	animation_player.play_backwards("popup")
