extends Control

@onready var scroll_container_h_bar : HScrollBar = $ColorRect/VBoxContainer/ScrollContainer.get_h_scroll_bar()
@onready var synced_scroll_bar : HScrollBar = $ColorRect/VBoxContainer/ScrollContainer/VBoxContainer/SyncedScrollBar
@onready var history_button : Button = $ColorRect/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/HistoryButton
@onready var simple_roll_button : Button = $ColorRect/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/SimpleRollButton

func _ready():
	var scroll_bar_style = preload("res://TextSettings/scroll_bar_style.tres")
	synced_scroll_bar.add_theme_stylebox_override("grabber", scroll_bar_style)
	synced_scroll_bar.add_theme_stylebox_override("grabber_highlight", scroll_bar_style)
	synced_scroll_bar.add_theme_stylebox_override("grabber_pressed", scroll_bar_style)
	
	history_button.scene_navigation_pressed.connect(SettingsManager.set_scrolled_scene)
	simple_roll_button.scene_navigation_pressed.connect(SettingsManager.set_scrolled_scene)
	SettingsManager.scene_scroll_value_changed.connect(set_scoll_value_deferred)
	SettingsManager.reconfigure.connect(deferred_reconfigure)
	
	deferred_reconfigure()
	
func deferred_reconfigure():
	call_deferred("reconfigure")

# Match our synced scroll bar to the size of the pages so that they line up with the buttons
func reconfigure():
	print("reconfiguring scene scroll bar")
	var page_size = SettingsManager.get_window_size().x
	synced_scroll_bar.max_value = page_size * SettingsManager.get_num_scrollable_scenes()
	synced_scroll_bar.page = page_size
	
# Set the scroll value, and match the scrolling of the buttons to match.
# If we have manually scrolled the bar in the direction of movement already, don't update that scrolling
# If you don't do this it has some jittery movements that look bad.
# The jittery movement still happens in reverse, but I think thats a less likely scenario and don't know how to solve.
func set_scoll_value_deferred(value: int):
	var current_synced_scroll_bar_value = synced_scroll_bar.value
	synced_scroll_bar.set_deferred("value", value)
	
	var current_scroll_container_h_bar_value = scroll_container_h_bar.value
	var synced_scroll_percent = value / synced_scroll_bar.max_value
	var new_scroll_container_h_bar_value = scroll_container_h_bar.max_value * synced_scroll_percent
	if(value > current_synced_scroll_bar_value and current_scroll_container_h_bar_value < new_scroll_container_h_bar_value):
		scroll_container_h_bar.set_deferred("value", new_scroll_container_h_bar_value)
	elif(value < current_synced_scroll_bar_value and current_scroll_container_h_bar_value > new_scroll_container_h_bar_value):
		scroll_container_h_bar.set_deferred("value", new_scroll_container_h_bar_value)
