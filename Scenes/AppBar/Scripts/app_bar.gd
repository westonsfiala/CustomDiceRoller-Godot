extends Control
class_name AppBar

@onready var scene_scroll_button_bar : Control = $ColorRect/VBoxContainer/SceneScrollButtonBar
@onready var vbox_container : VBoxContainer = $ColorRect/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SettingsManager.window_size_changed.connect(reconfigure)
	SettingsManager.button_size_changed.connect(reconfigure)
	reconfigure()
	
func reconfigure() -> void:
	custom_minimum_size.y = vbox_container.size.y
	

func _on_clear_history_button_pressed() -> void:
	pass

func _on_clear_history_popup_index_pressed(_index: int) -> void:
	print("Clearing History")
	RollManager.clear_roll_history()
