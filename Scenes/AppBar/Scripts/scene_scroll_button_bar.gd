extends Control

@onready var scroll_container_h_bar : HScrollBar = $ColorRect/ScrollContainer.get_h_scroll_bar()
@onready var synced_scroll_bar : HScrollBar = $ColorRect/ScrollContainer/VBoxContainer/SyncedScrollBar
@onready var settings_button : SceneButton = $ColorRect/ScrollContainer/VBoxContainer/HBoxContainer/SettingsButton
@onready var history_button : SceneButton = $ColorRect/ScrollContainer/VBoxContainer/HBoxContainer/HistoryButton
@onready var simple_roll_button : SceneButton = $ColorRect/ScrollContainer/VBoxContainer/HBoxContainer/SimpleRollButton

func _ready() -> void:
	settings_button.scene_navigation_pressed.connect(SettingsManager.set_scrolled_scene)
	history_button.scene_navigation_pressed.connect(SettingsManager.set_scrolled_scene)
	simple_roll_button.scene_navigation_pressed.connect(SettingsManager.set_scrolled_scene)
	SettingsManager.scene_scroll_value_changed.connect(set_scroll_value_deferred)
	SettingsManager.window_size_changed.connect(reconfigure)
	reconfigure()

# Match our synced scroll bar to the size of the pages so that they line up with the buttons
func reconfigure() -> void:
	var page_size : float = SettingsManager.get_window_size().x
	var margin_size : int = 5
	synced_scroll_bar.max_value = page_size * SettingsManager.get_num_scrollable_scenes()
	synced_scroll_bar.page = page_size
	synced_scroll_bar.custom_minimum_size.y = margin_size
	
# Set the scroll value, and match the scrolling of the buttons to match.
# If we have manually scrolled the bar in the direction of movement already, don't update that scrolling
# If you don't do this it has some jittery movements that look bad.
# The jittery movement still happens in reverse, but I think thats a less likely scenario and don't know how to solve.
func set_scroll_value_deferred(value: int) -> void:
	var current_synced_scroll_bar_value : float = synced_scroll_bar.value
	synced_scroll_bar.set_deferred("value", value)
	
	var current_scroll_container_h_bar_value : float = scroll_container_h_bar.value
	var synced_scroll_percent : float = value / synced_scroll_bar.max_value
	var new_scroll_container_h_bar_value : float = scroll_container_h_bar.max_value * synced_scroll_percent
	if(value > current_synced_scroll_bar_value and current_scroll_container_h_bar_value < new_scroll_container_h_bar_value):
		scroll_container_h_bar.set_deferred("value", new_scroll_container_h_bar_value)
	elif(value < current_synced_scroll_bar_value and current_scroll_container_h_bar_value > new_scroll_container_h_bar_value):
		scroll_container_h_bar.set_deferred("value", new_scroll_container_h_bar_value)
