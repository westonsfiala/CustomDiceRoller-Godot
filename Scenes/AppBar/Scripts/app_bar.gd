extends Control
class_name AppBar

@onready var scene_scroll_button_bar : Control = $ColorRect/VBoxContainer/SceneScrollButtonBar

# Called when the node enters the scene tree for the first time.
func _ready():
	SettingsManager.window_size_changed.connect(reconfigure)
	SettingsManager.button_size_changed.connect(reconfigure)
	reconfigure()
	
func reconfigure():
	var app_bar_height = SettingsManager.get_button_size()
	var screen_size = SettingsManager.get_window_size()
	
	custom_minimum_size.y = app_bar_height * 2
	
	scene_scroll_button_bar.custom_minimum_size = Vector2(screen_size.x, app_bar_height)
	

func _on_clear_history_button_pressed():
	pass
	#clear_history_popup.popup(Rect2i(clear_history_button.position, Vector2i.ZERO))

func _on_clear_history_popup_index_pressed(_index):
	print("Clearing History")
	RollManager.clear_roll_history()
