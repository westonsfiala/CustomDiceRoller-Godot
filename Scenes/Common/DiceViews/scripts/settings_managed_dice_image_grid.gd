extends Control
class_name SettingsManagedDiceImageGrid

@onready var flow_container : HFlowContainer = $HFlowContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Whenever the dice size changes, or our size is changed, add or remove dice
	SettingsManager.dice_size_changed.connect(reconfigure)
	resized.connect(reconfigure)
	reconfigure()

func reconfigure():
	var dice_size = SettingsManager.get_dice_size()
	custom_minimum_size.y = dice_size
	# Always have at least one row. Add a second under for smoother expansions without jitter.
	# Extras get clipped and a few extra doesn't tend to mess with performance.
	var rows: int = max(1, round(size.x / dice_size)) + 1
	var columns: int = max(1, round(size.y / dice_size)) + 1
	var needed_images = rows*columns
	var current_images = flow_container.get_child_count()
	
	# When we have too many images and need to remove them.
	if current_images > needed_images:
		# Remove the last child until we have the ammount we want.
		var flow_children = flow_container.get_children()
		for i in range(current_images - needed_images):
			var child_to_remove = flow_children.pop_back()
			flow_container.remove_child(child_to_remove)
			child_to_remove.queue_free()
	
	# When we have not enough images, add some more.
	if current_images < needed_images:
		for i in range(needed_images - current_images):
			var new_image = preload("res://Scenes/Common/DiceViews/settings_managed_dice_image.tscn").instantiate()
			flow_container.add_child(new_image)
			

