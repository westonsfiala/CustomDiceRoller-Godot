extends CollapsibleSettingBase
class_name DieResultSoundsSetting

@onready var enable_button : Button = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/DieResultContainer/EnableDisableContainer/EnableButton
@onready var disable_button : Button = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/DieResultContainer/EnableDisableContainer/DisableButton
@onready var die_result_container : VBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/DieResultContainer
@onready var die_result_sounds_container : VBoxContainer = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/DieResultContainer/DieResultSoundsContainer

const DIE_RESULT_SOUNDS_LABEL_TEXT : String = "Die Result Sounds - "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SettingsManager.die_result_sounds_enabled_changed.connect(reconfigure_buttons)
	SettingsManager.die_result_sounds_changed.connect(reconfigure_buttons)
	reconfigure_buttons()

# Send to the settings manager that we have updated.
func update_die_result_sounds() -> void:
	# Just set it to iteself to trigger the signal. We already modified the array.
	SettingsManager.set_die_result_sounds(SettingsManager.get_die_result_sounds())
	
# Make sure the buttons are nice and visible.
func reconfigure_buttons() -> void:
	if SettingsManager.get_die_result_sounds_enabled():
		enable_button.button_pressed = true
		disable_button.button_pressed = false
	else:
		enable_button.button_pressed = false
		disable_button.button_pressed = true

	
	# Set the die results
	var die_result_sounds : Array[DieResultSoundDescriptor] = SettingsManager.get_die_result_sounds()
	var die_result_sound_list_items : Array[Node] = die_result_sounds_container.get_children()
	
	# Add or remove items that we no longer need
	while die_result_sounds.size() > die_result_sound_list_items.size():
		var new_die_result_sound_list_item : DieResultSoundListItem = preload("res://Scenes/SettingsPage/die_result_sound_list_item.tscn").instantiate()
		new_die_result_sound_list_item.up_pressed.connect(_on_die_result_sound_list_item_up_pressed)
		new_die_result_sound_list_item.down_pressed.connect(_on_die_result_sound_list_item_down_pressed)
		new_die_result_sound_list_item.remove_pressed.connect(_on_die_result_sound_list_item_remove_pressed)
		new_die_result_sound_list_item.die_result_sound_changed.connect(_on_die_result_sound_list_item_changed)
		die_result_sounds_container.add_child(new_die_result_sound_list_item)
		die_result_sound_list_items = die_result_sounds_container.get_children()
	
	while die_result_sounds.size() < die_result_sound_list_items.size():
		var item_to_remove : Node = die_result_sound_list_items.back()
		die_result_sounds_container.remove_child(item_to_remove)
		item_to_remove.queue_free()
		die_result_sound_list_items = die_result_sounds_container.get_children()
		
	# Set the die results to match what the die_result_sounds has
	for index : int in die_result_sound_list_items.size():
		var die_result_sound : DieResultSoundDescriptor = die_result_sounds[index]
		var die_result_sound_list_item : Node = die_result_sound_list_items[index]
		die_result_sound_list_item.set_index(index)
		die_result_sound_list_item.set_die_result_sound(die_result_sound)
	
	show_hide_reset_button()
	set_title()
	
# Method for inherited class to get the title to display
func inner_get_title() -> String:
	var die_result_sounds_enabled_string : String = "Disabled"
	if SettingsManager.get_die_result_sounds_enabled():
		die_result_sounds_enabled_string = "Enabled"
	return str(DIE_RESULT_SOUNDS_LABEL_TEXT, die_result_sounds_enabled_string)
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return SettingsManager.get_die_result_sounds_enabled() != SettingsManager.DIE_RESULT_SOUNDS_ENABLED_DEFAULT

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed() -> void:
	SettingsManager.set_die_result_sounds_enabled(SettingsManager.DIE_RESULT_SOUNDS_ENABLED_DEFAULT)
	emit_signal("setting_changed")

# Set the die result sounds enabled to true.
func _on_enable_button_pressed() -> void:
	SettingsManager.set_die_result_sounds_enabled(true)
	emit_signal("setting_changed")

# Set the die result sounds enabled to false.
func _on_disable_button_pressed() -> void:
	SettingsManager.set_die_result_sounds_enabled(false)
	emit_signal("setting_changed")

# When a die result sound item has up pressed, move that sound up in the list.
func _on_die_result_sound_list_item_up_pressed(index: int) -> void:
	# Don't try to move something up that is already at the top.
	var die_result_sounds : Array[DieResultSoundDescriptor] = SettingsManager.get_die_result_sounds()
	if index > 0 and index < SettingsManager.get_die_result_sounds().size():
		var moved_sound : DieResultSoundDescriptor = die_result_sounds[index]
		die_result_sounds.remove_at(index)
		die_result_sounds.insert(index - 1, moved_sound)
		update_die_result_sounds()

# When a die result sound item has down pressed, move that sound down in the list.
func _on_die_result_sound_list_item_down_pressed(index: int) -> void:
	# Don't try to move something down that is already at the bottom.
	var die_result_sounds : Array[DieResultSoundDescriptor] = SettingsManager.get_die_result_sounds()
	if index > -1 and index < die_result_sounds.size()-1:
		var moved_sound : DieResultSoundDescriptor = die_result_sounds[index]
		die_result_sounds.remove_at(index)
		die_result_sounds.insert(index+1, moved_sound)
		update_die_result_sounds()

# When a die result sound item has remove pressed, remove that sound from the list.
func _on_die_result_sound_list_item_remove_pressed(index: int) -> void:
	var die_result_sounds : Array[DieResultSoundDescriptor] = SettingsManager.get_die_result_sounds()
	if index > -1 and index < die_result_sounds.size():
		die_result_sounds.remove_at(index)
		update_die_result_sounds()

# When a die result sound item changes, update the sound.
func _on_die_result_sound_list_item_changed(index: int, new_sound: DieResultSoundDescriptor) -> void:
	var die_result_sounds : Array[DieResultSoundDescriptor] = SettingsManager.get_die_result_sounds()
	if index > -1 and index < die_result_sounds.size():
		die_result_sounds[index] = new_sound
		update_die_result_sounds()

# Add a new die result sound.
func _on_add_die_result_sound_button_pressed() -> void:
	var new_die_result_sound : DieResultSoundDescriptor = DieResultSoundDescriptor.new()
	var random_valid_die : AbstractDie = SimpleRollManager.get_dice().pick_random()
	if random_valid_die != null:
		new_die_result_sound.die_name = random_valid_die.name()
		new_die_result_sound.die_result = str(random_valid_die.get_faces().pick_random())
		new_die_result_sound.sound_id = SoundManager.results_sounds.keys().pick_random()
		var die_result_sounds : Array[DieResultSoundDescriptor] = SettingsManager.get_die_result_sounds()
		die_result_sounds.append(new_die_result_sound)
		update_die_result_sounds()
