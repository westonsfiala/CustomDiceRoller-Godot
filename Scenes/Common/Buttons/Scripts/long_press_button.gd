extends Button
class_name LongPressButton

@onready var long_press_timer : Timer = $LongPressTimer

signal short_pressed
signal long_pressed

enum {WAITING, PRESSED, SENT}
var state = WAITING

# Start the timer when we press down
func _on_button_down():
	long_press_timer.start(SettingsManager.LONG_PRESS_DELAY)
	state = PRESSED

# Stop the timer if we don't time out before the button comes up
func _on_button_up():
	if(state == PRESSED):
		long_press_timer.stop()
		print("short press detected")
		emit_signal("short_pressed")
	state = WAITING
	
func _on_long_press_timer_timeout():
	if(state == PRESSED):
		print("long press detected")
		emit_signal("long_pressed")
		state = SENT

# Cancel any possible press if we are dragging the screen
func _on_gui_input(event):
	if event is InputEventScreenDrag:
		long_press_timer.stop() 
		state = WAITING
