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
	
func value_changed_helper(value: float):
	print(str("value = ", value))
	scroll_snap_timer.start(timer_duration)
	
func snap_scroll_to_page():
	scroll_snap_timer.stop()
	print("starting snap")
	var current_position = int(h_scroll_bar.value)
	var num_scenes = scene_container.get_child_count(false)
	var step_size = int(h_scroll_bar.max_value / num_scenes)
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
	
	
