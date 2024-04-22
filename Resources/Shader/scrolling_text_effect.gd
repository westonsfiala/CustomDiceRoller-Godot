@tool
extends RichTextEffect
class_name RichTextScroll

# Syntax: [scroll wait=1 duration=3 length=75][/scroll]

# Wait is how long you pause at the beginning and end of the scroling
# Duraion is how long you scroll for
# Lenght is how far you scroll to the left

# Define the tag name.
var bbcode : String = "scroll"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	# Get parameters, or use the provided default value if missing.
	var wait : float = char_fx.env.get("wait", 1.0)
	var duration : float = char_fx.env.get("duration", 3.0)
	var length : float = char_fx.env.get("length", 75)
	
	# Calculate how fast we should scroll
	var scroll_speed : float = length / duration
	
	# Modulate to get a duration that keeps looping
	var elapsed_loop_time : float = fmod(char_fx.elapsed_time, duration + wait*2)
	
	# Wait for some time, scroll, wait some more, repeat.
	# Go in reverse order so we get the desired effect
	if(elapsed_loop_time > duration + wait):
		char_fx.offset.x = -length
	elif(elapsed_loop_time > wait):
		var scroll_time : float = elapsed_loop_time - wait
		char_fx.offset.x = -scroll_time * scroll_speed
	elif(elapsed_loop_time < wait):
		char_fx.offset.x = 0

	return true
