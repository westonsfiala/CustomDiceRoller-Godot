extends CollapsibleSettingBase
class_name ShakeVolumeSetting

@onready var shake_volume_slider : HSlider = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/ShakeVolumeSlider

const SHAKE_VOLUME_LABEL_TEXT : String = "Volume - "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SettingsManager.shake_volume_changed.connect(reconfigure_slider)
	reconfigure_slider()
	
# Reconfigures the slider and its maximum value to be half the screen width
func reconfigure_slider() -> void:
	# Set the text and the current slider value.
	var new_volume : int = SettingsManager.get_shake_volume()
	shake_volume_slider.set_value_no_signal(new_volume)
	set_title()
	show_hide_reset_button()
	
# Called as the slider is being adjusted
func _on_shake_volume_slider_value_changed(_value : int) -> void:
	SettingsManager.set_shake_volume(int(shake_volume_slider.value))
	emit_signal("setting_changed")
	
func inner_get_title() -> String:
	return str(SHAKE_VOLUME_LABEL_TEXT, SettingsManager.get_shake_volume(), "%")
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return shake_volume_slider.value != SettingsManager.SHAKE_VOLUME_DEFAULT

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed() -> void:
	SettingsManager.set_shake_volume(SettingsManager.SHAKE_VOLUME_DEFAULT)
	emit_signal("setting_changed")
