extends PopupBase
class_name HalfScreenPopup

@onready var margins : MarginContainer = $ContentPanel/Margins
	
func set_content_panel_minimum_size() -> void:
	var screen_size : Vector2 = SettingsManager.get_window_size()
	var half_screen_square_size : Vector2 = Vector2.ONE * min(screen_size.x, screen_size.y) * 3 / 4
	content_panel.custom_minimum_size = half_screen_square_size

# Sets the contents to be whatever is passed in.
func set_content(margins_child: Node) -> void:
	# First thing is to get rid of all the current contents.
	SettingsManager.remove_and_free_children(margins)
	# Then add the new child.
	margins.add_child(margins_child)
