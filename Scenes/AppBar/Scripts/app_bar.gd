extends Control
class_name AppBar

@onready var name_label : Label = $ColorRect/VBoxContainer/Container/NameLabel
@onready var clear_history_button : Button = $ColorRect/VBoxContainer/Container/ClearHistoryButton
@onready var clear_history_image : TextureRect = $ColorRect/VBoxContainer/Container/ClearHistoryButton/ClearHistoryImage
@onready var clear_history_popup : PopupMenu = $ColorRect/VBoxContainer/Container/ClearHistoryButton/ClearHistoryPopup
@onready var scene_scroll_button_bar : Control = $ColorRect/VBoxContainer/SceneScrollButtonBar

# Called when the node enters the scene tree for the first time.
func _ready():
	SettingsManager.reconfigure.connect(deferred_reconfigure)
	deferred_reconfigure()
	
func deferred_reconfigure():
	call_deferred("reconfigure")
	
func reconfigure():
	print("reconfiguring app bar")
	var app_bar_size = SettingsManager.get_app_bar_size()
	var margin_padding = SettingsManager.get_margin_padding()
	var screen_size = SettingsManager.get_window_size()
	
	custom_minimum_size.y = app_bar_size * 2
	
	name_label.custom_minimum_size = Vector2(screen_size.x/2, app_bar_size)
	name_label.offset_left = margin_padding
	
	clear_history_button.custom_minimum_size = Vector2.ONE * app_bar_size
	clear_history_button.offset_left = margin_padding
	
	var clear_history_size = Vector2.ONE * (app_bar_size-margin_padding)
	clear_history_image.custom_minimum_size = clear_history_size
	clear_history_image.size = clear_history_size
	clear_history_image.position = Vector2.ONE * int(margin_padding/2.0)
	
	scene_scroll_button_bar.custom_minimum_size = Vector2(screen_size.x, app_bar_size)

func _on_clear_history_button_pressed():
	clear_history_popup.popup(Rect2i(clear_history_button.position, Vector2i.ZERO))

func _on_clear_history_popup_index_pressed(_index):
	print("Clearing History")
	RollManager.clear_roll_history()
