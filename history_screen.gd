extends Control

@onready var history_list : VBoxContainer = $ScrollContainer/HistoryList

# Called when the node enters the scene tree for the first time.
func _ready():
	RollManager.new_roll_result.connect(add_history_item)
	reconfigure()
	custom_minimum_size.x = SettingsManager.get_window_size().x

func reconfigure():
	SettingsManager.remove_and_free_children(history_list)
	for roll in RollManager.get_roll_history():
		add_history_item(roll)
		
func add_history_item(result: String):
	var history_item = preload("res://TextSettings/settings_managed_label.tscn").instantiate()
	history_list.add_child(history_item)
	history_list.move_child(history_item, 0)
	history_item.text = result

