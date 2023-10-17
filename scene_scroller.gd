extends ScrollContainer

var is_scrolling : bool = false
var timer_duration : float = 0.25
var tween_duration : float = 0.5

@onready var h_scroll_bar : HScrollBar = $".".get_h_scroll_bar()
@onready var scroll_snap_timer : Timer = $ScrollSnapTimer
@onready var scene_container : HBoxContainer = $SceneContainer

func _ready():
	h_scroll_bar.value_changed.connect(value_changed_helper)
	scroll_snap_timer.timeout.connect(snap_scroll_to_page)
	scroll_to_page(SettingsManager.get_default_app_page(), 0.0)
	
func _on_scroll_ended():
	call_deferred("snap_scroll_to_page")
	
func value_changed_helper(_value: float):
	scroll_snap_timer.start(timer_duration)
	
func scroll_to_page(page: int, duration: float):
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(h_scroll_bar, "value", page * SettingsManager.get_window_size().x, duration)
	
func snap_scroll_to_page():
	print("starting screen snap")
	scroll_snap_timer.stop()
	var current_position = int(h_scroll_bar.value)
	var step_size = int(SettingsManager.get_window_size().x)
	var step_remainer = current_position % step_size
	var destination_position = 0
	var move_distance = 0
	
	if(step_remainer >= int(step_size/2.0)):
		move_distance = step_size - step_remainer
		destination_position = current_position + move_distance
	else:
		move_distance = step_remainer
		destination_position = current_position - move_distance
		
	var duration_modifier = float(move_distance) / float(step_size/2.0)
		
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(h_scroll_bar, "value", destination_position, tween_duration * duration_modifier)

