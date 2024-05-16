extends HBoxContainer
class_name DieResultSoundListItem

@onready var die_name_option_button : OptionButton = $DieNameOptionButton
@onready var die_result_option_button : OptionButton = $DieResultOptionButton
@onready var sound_name_option_button : OptionButton = $SoundNameOptionButton

var die_result_sound_descriptor : DieResultSoundDescriptor = DieResultSoundDescriptor.new()

# Used for signaling.
var list_index : int = -1

signal die_result_sound_changed(index : int, new_die_result_sound : DieResultSoundDescriptor)
signal up_pressed(index : int)
signal down_pressed(index : int)
signal remove_pressed(index : int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SimpleRollManager.simple_dice_updated.connect(setup_die_name_option_button)
	reconfigure()
	
# Set up all of the drop down lists.
func reconfigure() -> void:
	# Setup the die name option button. This will also setup the result drop down.
	setup_die_name_option_button()
	setup_sound_name_option_button()

# Setup the die name option button.
func setup_die_name_option_button() -> void:
	die_name_option_button.clear()

	var no_die_selected : bool = true
	for die : AbstractDie in SimpleRollManager.get_dice():
		die_name_option_button.add_item(die.name())
		if die.name() == die_result_sound_descriptor.die_name:
			die_name_option_button.select(die_name_option_button.get_item_count() - 1)
			no_die_selected = false

	# If no die was selected add an option that says its missing.
	if no_die_selected:
		die_name_option_button.add_item(str(die_result_sound_descriptor.die_name, " (Not Found)"))
		die_name_option_button.select(die_name_option_button.get_item_count() - 1)

	setup_die_result_option_button()

# Setup the die result option button.
func setup_die_result_option_button() -> void:
	die_result_option_button.clear()

	# Get our selected die.
	var selected_die : AbstractDie = null
	for die : AbstractDie in SimpleRollManager.get_dice():
		if die.name() == die_result_sound_descriptor.die_name:
			selected_die = die
			break

	if selected_die:
		var no_result_selected : bool = true
		for face : Variant in selected_die.get_faces():
			var face_string : String = str(face)
			die_result_option_button.add_item(face_string)
			if face_string == die_result_sound_descriptor.die_result:
				die_result_option_button.select(die_result_option_button.get_item_count() - 1)
				no_result_selected = false
		
		# If no result was selected add an option that says its missing.
		if no_result_selected:
			die_result_option_button.add_item(str(die_result_sound_descriptor.die_result, " (Not Found)"))
			die_result_option_button.select(die_result_option_button.get_item_count() - 1)
	else:
		die_result_option_button.add_item(str(die_result_sound_descriptor.die_result, "(Unknown Die)"))
		die_result_option_button.select(die_result_option_button.get_item_count() - 1)

# Setup the sound name option button.
func setup_sound_name_option_button() -> void:
	sound_name_option_button.clear()
	for sound : StringName in SoundManager.results_sounds.keys():
		sound_name_option_button.add_item(sound)
		if sound == die_result_sound_descriptor.sound_id:
			sound_name_option_button.select(sound_name_option_button.get_item_count() - 1)

# Set the new die result sound descriptor.
func set_die_result_sound(new_die_result_sound: DieResultSoundDescriptor) -> void:
	die_result_sound_descriptor = new_die_result_sound
	setup_die_name_option_button()
	setup_sound_name_option_button()
	
# Set the index to the new index.
func set_index(new_index : int) -> void:
	list_index = new_index

# Send that this list item should be moved up.
func _on_up_button_pressed() -> void:
	emit_signal("up_pressed", list_index)

# Send that this list item should be moved down.
func _on_down_button_pressed() -> void:
	emit_signal("down_pressed", list_index)
	
# Send that this list item should be removed.
func _on_remove_button_pressed() -> void:
	# Without this the signal is sent before the mouse unpress event is processed.
	call_deferred("remove_button_helper")

# Helper method for removing self. 
func remove_button_helper() -> void:
	emit_signal("remove_pressed", list_index)

# When the die name is selected, update the die result drop down.
func _on_die_name_option_button_item_selected(index : int) -> void:
	die_result_sound_descriptor.die_name = die_name_option_button.get_item_text(index)
	setup_die_name_option_button()
	emit_signal("die_result_sound_changed", list_index, die_result_sound_descriptor)

# When the die result is selected, update the die result.
func _on_die_result_option_button_item_selected(index : int) -> void:
	die_result_sound_descriptor.die_result = die_result_option_button.get_item_text(index)
	setup_die_result_option_button()
	emit_signal("die_result_sound_changed", list_index, die_result_sound_descriptor)

# When a new sound is selected, update the die result.
func _on_sound_name_option_button_item_selected(index : int) -> void:
	die_result_sound_descriptor.sound_id = sound_name_option_button.get_item_text(index)
	setup_sound_name_option_button()
	emit_signal("die_result_sound_changed", list_index, die_result_sound_descriptor)

