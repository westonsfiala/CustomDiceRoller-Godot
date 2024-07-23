extends Control
class_name SavedRoll

@onready var no_saved_roll_label : Label = $NoSavedRollLabel
@onready var saved_roll_container : VBoxContainer = $ScrollContainer/SavedRollContainer

# Connect to the settings manager and setup the scene with all of our dice
func _ready() -> void:
	SettingsManager.window_size_changed.connect(reconfigure)
	SavedRollManager.saved_roll_updated.connect(saved_roll_updated)
	saved_roll_updated()
	reconfigure()

# Make sure that we are sized properly
func reconfigure() -> void:
	custom_minimum_size.x = SettingsManager.get_window_size().x
	
func saved_roll_updated() -> void:
	SettingsManager.remove_and_free_children(saved_roll_container)
	# TODO: Implement the saved roll fill out.
	refresh_no_saved_rolls()

# Roll the saved roll that was clicked and set the results
func roll_saved_roll(saved_roll: CustomRollModel) -> void:
	RollManager.custom_roll(saved_roll)
	
# Opens a dialog to edit the roll
func edit_saved_roll(_saved_roll: CustomRollModel) -> void:
	# TODO: implement the new save roll dialog.
	pass
	
func refresh_no_saved_rolls() -> void:
	var saved_rolls : Array[CustomRollModel] = SavedRollManager.get_saved_rolls()
	if saved_rolls.is_empty():
		no_saved_roll_label.visible = true
	else:
		no_saved_roll_label.visible = false

