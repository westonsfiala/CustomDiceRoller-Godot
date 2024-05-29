extends HBoxContainer
class_name CustomRollListItem

@onready var up_button : Button = $UpDownButtonsLayout/UpButton
@onready var delete_button : Button = $UpDownButtonsLayout/DeleteButton
@onready var down_button : Button = $UpDownButtonsLayout/DownButton

@onready var dice_image : TextureRect = $DieViewLayout/DiceImage
@onready var dice_name : SettingsManagedRichTextLabel = $DieViewLayout/DiceName

@onready var num_dice_updown : UpDownButtons = $PropertiesLayout/NumDiceUpDown
@onready var modifier_updown : UpDownButtons = $PropertiesLayout/ModifierUpDown
@onready var property_button : PropertyButton = $PropertiesLayout/PropertyButton



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
