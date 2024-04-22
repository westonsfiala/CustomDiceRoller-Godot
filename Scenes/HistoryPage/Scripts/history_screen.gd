extends Control

@onready var history_list : VBoxContainer = $ScrollContainer/MarginContainer/HistoryList
@onready var no_history_label : Label = $EmptyHistoryLabel
@onready var restore_history_container : MarginContainer = $MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RollManager.new_roll_result.connect(add_history_item)
	RollManager.refresh_history.connect(reconfigure)
	SettingsManager.window_size_changed.connect(reconfigure)
	reconfigure()

func reconfigure() -> void:
	custom_minimum_size.x = SettingsManager.get_window_size().x
	SettingsManager.remove_and_free_children(history_list)
	# Need to reverse the history otherwise it will put everything in bad order.
	var roll_history : Array[RollResults] = RollManager.get_roll_history().duplicate(true)
	roll_history.reverse()
	for roll : RollResults in roll_history:
		add_history_item(roll)
	refresh_no_history()

# Add a roll result to the history. If any history items already exist, add a speparator as well.
func add_history_item(roll_result: RollResults) -> void:
	if(history_list.get_child_count() != 0):
		var separator : HSeparator = HSeparator.new()
		history_list.add_child(separator)
		history_list.move_child(separator, 0)
	var history_item : HistoryItem = preload("res://Scenes/HistoryPage/history_item.tscn").instantiate().configure(roll_result)
	history_list.add_child(history_item)
	history_list.move_child(history_item, 0)
	refresh_no_history()
	
func refresh_no_history() -> void:
	var roll_history : Array[RollResults] = RollManager.get_roll_history()
	if roll_history.is_empty():
		no_history_label.visible = true
	else:
		no_history_label.visible = false
		
	if RollManager.has_cleared_history():
		restore_history_container.visible = true
	else:
		restore_history_container.visible = false
		
func _on_restore_history_button_short_pressed() -> void:
	RollManager.restore_roll_history()
