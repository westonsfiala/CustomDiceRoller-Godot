extends Control
class_name DiceSettingsPage

@onready var settings_container : VBoxContainer = $TopLevelContainer
@onready var dice_settings_button : Button = $TopLevelContainer/SettingsTitleContainer/DiceGroupRichTextLabel/Button
@onready var dice_settings_group : Control = $TopLevelContainer/DiceSettingsGroup
@onready var settings_arrow : SettingsManagedTextureButton = $TopLevelContainer/SettingsTitleContainer/SettingsArrow

var tween : Tween = null

# Called when the node enters the scene tree for the first time.
func _ready():
	custom_minimum_size.y = settings_container.size.y
	start_collapsed()
	
# Start with the setting collapsed
func start_collapsed():
	# You have to do this weird tween stuff because setting the rotation directly
	# doesn't work for some unknown reason.
	tween = get_tree().create_tween()
	tween.tween_property(settings_arrow, "rotation_degrees", -90, 0).from(0)
	dice_settings_group.scale = Vector2(1,0)
	dice_settings_group.visible = false

# Toggle showing/hiding the dice settings.
func _on_button_pressed():
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	if dice_settings_group.visible:
		tween.tween_property(settings_arrow, "rotation_degrees", -90, SettingsManager.LONG_PRESS_DELAY).from(0)
		tween.tween_property(dice_settings_group, "scale", Vector2(1, 0), SettingsManager.LONG_PRESS_DELAY).from(Vector2.ONE)
		tween.chain().tween_property(dice_settings_group, "visible", false, 0)
	else:
		dice_settings_group.visible = true
		tween.tween_property(settings_arrow, "rotation_degrees", 0, SettingsManager.LONG_PRESS_DELAY).from(-90)
		tween.tween_property(dice_settings_group, "scale", Vector2.ONE, SettingsManager.LONG_PRESS_DELAY).from(Vector2(1, 0))
