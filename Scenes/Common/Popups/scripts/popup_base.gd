extends Popup
class_name PopupBase

@onready var content_panel : Panel = $ContentPanel
@onready var hide_popup_button : Button = $HidePopupButton

var tween : Tween

func _ready() -> void:
	SettingsManager.window_size_changed.connect(reconfigure)
	reconfigure()

# Reconfigures the scene according to the settings
func reconfigure() -> void:
	hide()
	
func modular_popup(display_position: Vector2i) -> void:
	size = SettingsManager.get_window_size()
	set_content_panel_minimum_size()
	enforce_content_panel_in_screen(display_position, false)
	popup(Rect2i(Vector2.ZERO, size))

func modular_popup_center() -> void:
	size = SettingsManager.get_window_size()
	set_content_panel_minimum_size()
	enforce_content_panel_in_screen(size/2, true)
	popup(Rect2i(Vector2.ZERO, size))

# Pops up the panel at the bottom center of the screen
func modular_popup_bottom_center() -> void:
	size = SettingsManager.get_window_size()
	set_content_panel_minimum_size()
	var bottom_center : Vector2 = Vector2(size.x / 2.0, size.y)
	enforce_content_panel_in_screen(bottom_center, true)
	popup(Rect2i(Vector2.ZERO, size))
	
func set_content_panel_minimum_size() -> void:
	assert(false, "This must be set by consumers of PopupBase")
	
func enforce_content_panel_in_screen(content_position: Vector2i, center_contents: bool) -> void:
	var valid_rect : Rect2i = Rect2i(Vector2i.ZERO, SettingsManager.get_window_size())
	var content_rect : Rect2i = Rect2i(content_position, content_panel.custom_minimum_size)
	
	if(center_contents):
		content_rect.position -= content_rect.size / 2
	
	# Force size to always be within 10 of all edges
	if(content_rect.size.x > valid_rect.size.x - 20):
		content_rect.size.x = valid_rect.size.x - 20
	if(content_rect.size.y > valid_rect.size.y - 20):
		content_rect.size.y = valid_rect.size.y - 20
		
	# Force contents to be at least 10 pixels away from the edges
	if(content_rect.position.x < 10):
		content_rect.position.x = 10
	if(content_rect.position.x + content_rect.size.x > valid_rect.size.x - 10):
		content_rect.position.x = valid_rect.size.x - content_rect.size.x - 10
	if(content_rect.position.y < 10):
		content_rect.position.y = 10
	if(content_rect.position.y + content_rect.size.y > valid_rect.size.y - 10):
		content_rect.position.y = valid_rect.size.y - content_rect.size.y - 10
	
	# Set the panel size to our valid position
	content_panel.position = content_rect.position
	content_panel.custom_minimum_size = content_rect.size
	content_panel.size = content_rect.size
	content_panel.pivot_offset = content_rect.size / 2

func _on_about_to_popup() -> void:
	SettingsManager.fake_mouse_unpress()
	animate_popup()

func _on_hide_popup_button_pressed() -> void:
	animate_close_popup()
	
# Animates the popup opening
func animate_popup() -> void:
	# Don't animate if we're already animating
	if(tween and tween.is_running()):
		return
	content_panel.scale = Vector2.ZERO
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(content_panel, 'scale', Vector2.ONE, SettingsManager.LONG_PRESS_DELAY)

# Animates the popup closing	
func animate_close_popup() -> void:
	# Don't animate if we're already animating
	if(tween and tween.is_running()):
		return
	visible = true
	content_panel.scale = Vector2.ONE
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(content_panel, 'scale', Vector2.ZERO, SettingsManager.LONG_PRESS_DELAY)
	tween.tween_callback(hide)
