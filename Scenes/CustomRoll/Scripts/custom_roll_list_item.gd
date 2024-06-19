extends HBoxContainer
class_name CustomRollListItem

@onready var up_button : Button = $VBoxContainer/HBoxContainer/UpDownButtonsLayout/UpButton
@onready var delete_button : Button = $VBoxContainer/HBoxContainer/UpDownButtonsLayout/DeleteButton
@onready var down_button : Button = $VBoxContainer/HBoxContainer/UpDownButtonsLayout/DownButton

@onready var dice_image : SettingsManagedDiceImage = $VBoxContainer/HBoxContainer/DieViewLayout/DiceImage
@onready var dice_name : SettingsManagedRichTextLabel = $VBoxContainer/HBoxContainer/DieViewLayout/DiceName

@onready var num_dice_updown : UpDownButtons = $VBoxContainer/HBoxContainer/PropertiesLayout/NumDiceUpDownButtons
@onready var modifier_updown : UpDownButtons = $VBoxContainer/HBoxContainer/PropertiesLayout/ModifierUpDownButtons
@onready var property_button : PropertyButton = $VBoxContainer/HBoxContainer/PropertiesLayout/PropertyButton

@onready var separator : HSeparator = $VBoxContainer/HSeparator

var die_prop_pair : DiePropertyPair = DiePropertyPair.new().configure(SimpleRollManager.default_min_max_die, RollProperties.new())
var index : int = -1

signal properties_changed(index: int, die_prop_pair: DiePropertyPair)
signal up_pressed(index: int)
signal down_pressed(index: int)
signal remove_pressed(index: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SettingsManager.button_size_changed.connect(reconfigure)
	reconfigure()
	update_properties()

func reconfigure() -> void:
	dice_image.custom_minimum_size = Vector2.ONE * SettingsManager.get_button_size() * 2
	call_deferred("reset_dice_size")
	set_die_property_pair(die_prop_pair)

func reset_dice_size() -> void:
	dice_image.size = dice_image.custom_minimum_size

# Set the new die prop pair without a signal.
func set_die_property_pair(new_die_prop_pair: DiePropertyPair) -> void:
	die_prop_pair = new_die_prop_pair
	dice_name.set_text_and_resize_y_centered(die_prop_pair.m_die.name())
	dice_image.configure_image(die_prop_pair.m_die.texture())
	update_properties()

# Set update the property buttons without a signal.
func update_properties() -> void:
	var num_dice: int = die_prop_pair.m_roll_properties.get_num_dice()
	dice_image.set_negate_color(num_dice < 0)
	num_dice_updown.set_value(num_dice)
	modifier_updown.set_value(die_prop_pair.m_roll_properties.get_modifier())
	property_button.set_properties(die_prop_pair.m_roll_properties)

# External method for showing/hiding the separator.
func set_separator_visible(separator_visibility: bool) -> void:
	separator.visible = separator_visibility
	
# Set the index to the new index.
func set_index(new_index: int) -> void:
	index = new_index

# Send that this list item should be moved up.
func _on_up_button_pressed() -> void:
	emit_signal("up_pressed", index)

# Send that this list item should be moved down.
func _on_down_button_pressed() -> void:
	emit_signal("down_pressed", index)
	
# Send that this list item should be removed.
func _on_remove_button_pressed() -> void:
	# Without this the signal is sent before the mouse unpress event is processed.
	call_deferred("remove_button_helper")

# Helper method for removing self. 
func remove_button_helper() -> void:
	emit_signal("remove_pressed", index)

# When property reset is pressed, reset our properties.
func _on_property_button_reset_properties() -> void:
	die_prop_pair.m_roll_properties = RollProperties.new()
	send_update()

# When the property button is updated, update our properties.
func _on_property_button_properties_updated(properties: RollProperties) -> void:
	die_prop_pair.m_roll_properties = properties
	send_update()

# When the modifier is updated, update our properties.
func _on_modifier_up_down_value_changed(value:int) -> void:
	die_prop_pair.m_roll_properties.set_modifier(value)
	send_update()

# When the number of dice is updated, update our properties.
func _on_num_dice_up_down_value_changed(value:int) -> void:
	die_prop_pair.m_roll_properties.set_num_dice(value)
	send_update()

func send_update() -> void:
	emit_signal("properties_changed", index, die_prop_pair)
	update_properties()
