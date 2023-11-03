extends Control

@onready var margin_container : MarginContainer = $MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	SettingsManager.reconfigure.connect(reconfigure)
	call_deferred("reconfigure")
	
# Reconfigures the scene according to the settings
func reconfigure():
	print("reconfiguring texture button")
	var margin_padding = SettingsManager.get_margin_padding()
	
	margin_container.add_theme_constant_override("margin_left", margin_padding)
	margin_container.add_theme_constant_override("margin_right", margin_padding)
