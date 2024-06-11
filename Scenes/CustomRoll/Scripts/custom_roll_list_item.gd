extends HBoxContainer
class_name CustomRollListItem

@onready var up_button : Button = $UpDownButtonsLayout/UpButton
@onready var delete_button : Button = $UpDownButtonsLayout/DeleteButton
@onready var down_button : Button = $UpDownButtonsLayout/DownButton

@onready var dice_image : TextureRect = $DieViewLayout/DiceImage
@onready var dice_name : SettingsManagedRichTextLabel = $DieViewLayout/DiceName

@onready var num_dice_updown : UpDownButtons = $PropertiesLayout/NumDiceUpDownButtons
@onready var modifier_updown : UpDownButtons = $PropertiesLayout/ModifierUpDownButtons
@onready var property_button : PropertyButton = $PropertiesLayout/PropertyButton

var dice : AbstractDie = SimpleRollManager.default_die
var roll_properties : RollProperties = RollProperties.new()
var index : int = -1

signal properties_changed(index: int, properties: RollProperties)
signal up_pressed(index: int)
signal down_pressed(index: int)
signal remove_pressed(index: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_properties()

# Set the color without a signal.
func set_roll_properties(properties: RollProperties) -> void:
	roll_properties = properties
	update_properties()

# Set update the property buttons without a signal.
func update_properties() -> void:
	num_dice_updown.set_value(roll_properties.get_num_dice())
	modifier_updown.set_value(roll_properties.get_modifier())
	property_button.set_properties(roll_properties)
	
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
	roll_properties = RollProperties.new()
	emit_signal("properties_changed", index, roll_properties)
	update_properties()

# When the property button is updated, update our properties.
func _on_property_button_properties_updated(properties: RollProperties) -> void:
	pass # Replace with function body.

# When the number of dice is updated, update our properties.
func _on_modifier_up_down_value_changed(value:int) -> void:
	pass # Replace with function body.

# When the modifier is updated, update our properties.
func _on_num_dice_up_down_value_changed(value:int) -> void:
	pass # Replace with function body.
