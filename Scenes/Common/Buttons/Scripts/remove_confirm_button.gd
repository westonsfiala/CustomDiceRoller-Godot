extends Control
class_name RemoveConfirmButton

@onready var remove_button : LongPressButton = $RemoveButton
@onready var progress_bar : ProgressBar = $RemoveButton/ProgressBar

var tween : Tween

enum {WAITING, CONFIRMING}
var state = WAITING

signal remove_confirmed()

func _ready():
	reset_button()
	
func reset_button():
	state = WAITING
	remove_button.text = "Remove"
	progress_bar.visible = false

func _on_remove_button_pressed():
	if(state == WAITING):
		state = CONFIRMING
		remove_button.text = "Confirm"
		if(tween):
			tween.kill()
		tween = get_tree().create_tween()
		progress_bar.visible = true
		tween.tween_method(handle_confirm, 100, 0, SettingsManager.LONG_PRESS_DELAY * 2)
		tween.finished.connect(handle_tween_finished)
	elif(state == CONFIRMING):
		print("remove confirmed")
		emit_signal("remove_confirmed")
		handle_tween_finished()
		
func handle_confirm(new_percent: float):
	progress_bar.value = new_percent
	
func handle_tween_finished():
	tween.kill()
	reset_button()
