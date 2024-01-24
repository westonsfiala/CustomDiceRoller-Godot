extends CollapsibleSettingBase
class_name TopLevelDiceSettings

@onready var settings_container : HBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/SettingsContainer
@onready var image_container : HBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/ImageContainer
@onready var dice_size_setting : DiceSizeSetting = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/SettingsContainer/SettingsVContainer/DiceSizeSetting
@onready var dice_visualizer : SettingsManagedDiceImage = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/ImageContainer/SettingsManagedDiceImage

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	dice_size_setting.reset_pressed.connect(show_hide_reset_button)
	dice_size_setting.minimum_size_changed.connect(enforce_all_content_shown)
	dice_visualizer.minimum_size_changed.connect(enforce_all_content_shown)

# Method for inherited class to get the minimum height of the collapsible section
func inner_get_collapsible_section_minimum_height() -> int:
	return max(settings_container.size.y, image_container.size.y)
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	var should_show = false
	should_show = should_show or dice_size_setting.inner_should_show_reset_button()
	return should_show

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed():
	dice_size_setting.inner_reset_button_pressed()
