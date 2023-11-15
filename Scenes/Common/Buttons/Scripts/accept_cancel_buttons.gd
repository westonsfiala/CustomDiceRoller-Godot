extends Control
class_name AcceptCancelButtons

@onready var cancel_button : Button = $HBoxContainer/CancelButton
@onready var accept_button : Button = $HBoxContainer/AcceptButton

signal accept_pressed()
signal cancel_pressed()

func _on_cancel_button_pressed():
	emit_signal("cancel_pressed")

func _on_accept_button_pressed():
	emit_signal("accept_pressed")

func disable_accept():
	accept_button.disabled = true
	
func enable_accept():
	accept_button.disabled = false
