extends Popup
class_name PopupBase


@onready var content_panel : Panel = $ContentPanel
@onready var hide_popup_button : Button = $HidePopupButton

var tween : Tween

func _ready():
	SettingsManager.reconfigure.connect(reconfigure)
	deferred_reconfigure()
	
func deferred_reconfigure():
	call_deferred("reconfigure")

# Reconfigures the scene according to the settings
func reconfigure():
	hide()
	
func modular_popup(display_position: Vector2i):
	size = SettingsManager.get_window_size()
	set_content_panel_minimum_size()
	enforce_content_panel_in_screen(display_position, false)
	popup(Rect2i(Vector2.ZERO, size))

func modular_popup_center():
	size = SettingsManager.get_window_size()
	set_content_panel_minimum_size()
	enforce_content_panel_in_screen(size/2, true)
	popup(Rect2i(Vector2.ZERO, size))
	
func set_content_panel_minimum_size():
	assert(false, "This must be set by consumers of PopupBase")
	
func enforce_content_panel_in_screen(content_position: Vector2i, center_contents: bool):
	var valid_rect = Rect2i(Vector2i.ZERO, SettingsManager.get_window_size())
	var content_rect = Rect2i(content_position, content_panel.custom_minimum_size)
	
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

func _on_about_to_popup():
	SettingsManager.fake_mouse_unpress()
	animate_popup()

func _on_hide_popup_button_pressed():
	animate_close_popup()
	
func animate_popup():
	if(tween):
		tween.kill()
	content_panel.scale = Vector2.ZERO
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(content_panel, 'scale', Vector2.ONE, SettingsManager.LONG_PRESS_DELAY)
	
func animate_close_popup():
	if(tween):
		tween.kill()
	visible = true
	content_panel.scale = Vector2.ONE
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(content_panel, 'scale', Vector2.ZERO, SettingsManager.LONG_PRESS_DELAY)
	tween.tween_property(self, 'visible', false, 0)
