extends Control
class_name RemoveConfirmButton

@onready var remove_button : LongPressButton = $RemoveButton
@onready var progress_bar : ProgressBar = $RemoveButton/ProgressBar

var tween : Tween

enum wait_state {WAITING, CONFIRMING}
var state : wait_state = wait_state.WAITING

signal remove_confirmed()

func _ready() -> void:
	reset_button()
	
func reset_button() -> void:
	state = wait_state.WAITING
	remove_button.text = "Remove"
	progress_bar.visible = false

func _on_remove_button_pressed() -> void:
	if(state == wait_state.WAITING):
		state = wait_state.CONFIRMING
		remove_button.text = "Confirm"
		if(tween):
			tween.kill()
		tween = get_tree().create_tween()
		progress_bar.visible = true
		tween.tween_method(handle_confirm, 100, 0, SettingsManager.LONG_PRESS_DELAY * 2)
		tween.finished.connect(handle_tween_finished)
	elif(state == wait_state.CONFIRMING):
		print("remove confirmed")
		emit_signal("remove_confirmed")
		handle_tween_finished()
		
func handle_confirm(new_percent: float) -> void:
	progress_bar.value = new_percent
	
func handle_tween_finished() -> void:
	tween.kill()
	reset_button()
