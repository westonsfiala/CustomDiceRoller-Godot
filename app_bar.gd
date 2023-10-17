extends Control
class_name AppBar

@onready var name_label : Label = $ColorRect/NameLabel
@onready var clear_history_button : Button = $ColorRect/ClearHistoryButton
@onready var clear_history_image : TextureRect = $ColorRect/ClearHistoryButton/ClearHistoryImage

# Called when the node enters the scene tree for the first time.
func _ready():
	SettingsManager.reconfigure.connect(reconfigure)
	call_deferred("reconfigure")
	
func reconfigure():
	var app_bar_size = SettingsManager.get_app_bar_size()
	var margin_padding = SettingsManager.get_margin_padding()
	var screen_size = SettingsManager.get_window_size()
	
	custom_minimum_size.y = app_bar_size
	
	name_label.custom_minimum_size = Vector2(screen_size.x/2, app_bar_size)
	name_label.offset_left = margin_padding
	
	clear_history_button.custom_minimum_size = Vector2.ONE * app_bar_size
	clear_history_button.offset_left = margin_padding
	
	var clear_history_size = Vector2.ONE * (app_bar_size-margin_padding)
	clear_history_image.custom_minimum_size = clear_history_size
	clear_history_image.size = clear_history_size
	clear_history_image.position = Vector2.ONE * int(margin_padding/2.0)

func _on_clear_history_button_pressed():
	print("Clear History Pressed")
