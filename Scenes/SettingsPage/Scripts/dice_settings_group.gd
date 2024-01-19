extends Control
class_name DiceSettingsPage

@onready var settings_container : VBoxContainer = $SettingsHContainer/SettingsVContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	custom_minimum_size.y = settings_container.size.y

