extends Control

@onready var history_list : VBoxContainer = $ScrollContainer/HistoryList

# Called when the node enters the scene tree for the first time.
func _ready():
	RollManager.new_roll_result.connect(add_history_item)
	RollManager.refresh_history.connect(deferred_reconfigure)
	SettingsManager.reconfigure.connect(deferred_reconfigure)
	deferred_reconfigure()
	
func deferred_reconfigure():
	call_deferred("reconfigure")

func reconfigure():
	print("reconfiguring history screen")
	custom_minimum_size.x = SettingsManager.get_window_size().x
	SettingsManager.remove_and_free_children(history_list)
	for roll in RollManager.get_roll_history():
		add_history_item(roll)
		
func add_history_item(result: String):
	var history_item = preload("res://TextSettings/settings_managed_label.tscn").instantiate()
	history_list.add_child(history_item)
	history_list.move_child(history_item, 0)
	history_item.text = result

