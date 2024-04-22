extends Button
class_name LongPressButton

@onready var long_press_timer : Timer = $LongPressTimer

signal short_pressed
signal long_pressed

enum button_state {WAITING, PRESSED, SENT}
var state : button_state = button_state.WAITING
var last_click_position : Vector2

# Start the timer when we press down
func _on_button_down() -> void:
	last_click_position = get_global_mouse_position()
	long_press_timer.start(SettingsManager.LONG_PRESS_DELAY)
	state = button_state.PRESSED

# Stop the timer if we don't time out before the button comes up
func _on_button_up() -> void:
	if(state == button_state.PRESSED):
		state = button_state.SENT
		long_press_timer.stop()
		emit_signal("short_pressed")
	else:
		state = button_state.WAITING
		
func _on_long_press_timer_timeout() -> void:
	if(state == button_state.PRESSED):
		state = button_state.SENT
		emit_signal("long_pressed")

# Cancel any possible press if we are dragging the screen or moving the mouse
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag or event is InputEventMouseMotion:
		if last_click_position:
			var move_length : float = (last_click_position - get_global_mouse_position()).length()
			if move_length > 5:
				long_press_timer.stop() 
				state = button_state.WAITING
