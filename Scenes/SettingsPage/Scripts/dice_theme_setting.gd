extends Control
class_name DiceThemeSetting

@onready var die_theme_label : SettingsManagedRichTextLabel = $TopContainer/TextContainer/DieThemeRichTextLabel
@onready var reset_button : Button = $TopContainer/TextContainer/ResetButton
@onready var top_container : VBoxContainer = $TopContainer
@onready var text_container : HBoxContainer = $TopContainer/TextContainer

const DIE_SIZE_LABEL_TEXT : String = "Die Theme - "

# Connect to the setting we will be modifying
func _ready():
	SettingsManager.button_size_changed.connect(reconfigure_theme_selector)
	SettingsManager.dice_theme_changed.connect(reconfigure_theme_selector)
	reconfigure_theme_selector()

# Reconfigures the theme selector to be the correct size
func reconfigure_theme_selector():
	text_container.custom_minimum_size.y = SettingsManager.get_button_size()
	custom_minimum_size.y = top_container.size.y
	hide_reset_button()
	
func hide_reset_button():
	if SettingsManager.get_dice_theme() == SettingsManager.DICE_THEME_DEFAULT:
		reset_button.visible = false
	else:
		reset_button.visible = true

# Reset the dice theme to the default
func _on_reset_button_pressed():
	SettingsManager.set_dice_theme(SettingsManager.DICE_THEME_DEFAULT)
