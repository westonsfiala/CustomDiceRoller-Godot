extends Node

# the dictionaries use the human readable name of the sound as the key and the path to the sound as the value
const ROLLER_SOUNDS_PATH : String = "res://Sounds/Roller"
var roller_sounds : Dictionary = {}

const RESULTS_SOUNDS_PATH : String = "res://Sounds/Results"
var results_sounds : Dictionary = {}

var TripleAirhorn : DieResultSoundDescriptor = DieResultSoundDescriptor.new().configure("d20", "20", "TripleAirhorn")
var WilhelmScream : DieResultSoundDescriptor = DieResultSoundDescriptor.new().configure("d20", "1", "WilhelmScream")
var default_sound_descriptors_list : Array[DieResultSoundDescriptor] = [TripleAirhorn, WilhelmScream]

var audio_player : AudioStreamPlayer = null
const SHAKE_AUDIO_BUS_NAME: StringName = "Shake"

func _ready() -> void:
	process_sounds()
	audio_player = AudioStreamPlayer.new()
	audio_player.bus = SHAKE_AUDIO_BUS_NAME
	add_child(audio_player)

# Go through all of the sound files in the Sounds folder and add them to the appropraite dictionaries
func process_sounds() -> void:
	var roller_sound_files : PackedStringArray = DirAccess.get_files_at(ROLLER_SOUNDS_PATH)

	for sound_file : String in roller_sound_files:
		if sound_file.get_extension() == "mp3":
			var sound_key : String = sound_file.get_file().get_basename().to_pascal_case()
			roller_sounds[sound_key] = ROLLER_SOUNDS_PATH + '/' + sound_file

	var results_sound_files : PackedStringArray = DirAccess.get_files_at(RESULTS_SOUNDS_PATH)

	for sound_file : String in results_sound_files:
		if sound_file.get_extension() == "mp3":
			var sound_key : String = sound_file.get_file().get_basename().to_pascal_case()
			results_sounds[sound_key] = RESULTS_SOUNDS_PATH + '/' + sound_file

# Play the sound associated with the roll result if any exist.
func process_results_sound(roll_result: RollResults) -> void:
	# If no sound playing is wanted, don't.
	if SettingsManager.get_die_result_sounds_enabled():
		# For each sound, go through and see if we should play it.
		for potential_sound : DieResultSoundDescriptor in SettingsManager.get_die_result_sounds():
			# If all the results are that given value, play the sound.
			if roll_result.search_for_die_result_sound_matching(potential_sound):
				# If the sound exists, play it.
				var sound_path : String = results_sounds[potential_sound.sound_id]
				if sound_path != null:
					audio_player.stream = load(sound_path)
					audio_player.play()
					return


