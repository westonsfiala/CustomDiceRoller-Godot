extends Node

const DIE_UNKNOWN : int = -1
const DIE_FATE : int = 0
const DIE_2 : int = 2
const DIE_3 : int = 3
const DIE_4 : int = 4
const DIE_6 : int = 6
const DIE_8 : int = 8
const DIE_10 : int = 10
const DIE_12 : int = 12
const DIE_20 : int = 20
const DIE_100 : int = 100

enum THEME {
	AGENDER,
	AROMANTIC,
	ASEXUAL,
	BEACH,
	BISEXUAL,
	COMMUNITY_LESBIAN,
	CREAMSICLE,
	CUSTOM_1,
	CUSTOM_2,
	CUSTOM_3,
	FIRE,
	FOREST,
	GENDERFLUID,
	GENDERQUEER,
	GOLD,
	INTERSEX,
	LGBT,
	LIPSTICK_LESBIAN,
	MINT_CHOCOLATE,
	NON_BINARY,
	PANSEXUAL,
	POLYSEXUAL,
	RAINBOW,
	RANDOM,
	RANDOM_MATCHING,
	RGB,
	SHERBERT,
	STEEL,
	SUPERMAN,
	TRANSGENDER,
	WHITE
}

const CUSTOM_GRADIENT_1_FILE_NAME : StringName = "user://custom_gradient_1.tres"
var custom_gradient_1 : CustomGradient = CustomGradient.new()
const CUSTOM_GRADIENT_2_FILE_NAME : StringName = "user://custom_gradient_2.tres"
var custom_gradient_2 : CustomGradient = CustomGradient.new()
const CUSTOM_GRADIENT_3_FILE_NAME : StringName = "user://custom_gradient_3.tres"
var custom_gradient_3 : CustomGradient = CustomGradient.new()

var loaded_themes : Dictionary = {}

func _ready():
	randomize_random_match()
	load_state()
	
func save_state():
	var save_result1 = ResourceSaver.save(custom_gradient_1, CUSTOM_GRADIENT_1_FILE_NAME)
	if save_result1 != OK: 
		print("Failed to save custom gradient 1")
	var save_result2 = ResourceSaver.save(custom_gradient_2, CUSTOM_GRADIENT_2_FILE_NAME)
	if save_result2 != OK: 
		print("Failed to save custom gradient 2")
	var save_result3 = ResourceSaver.save(custom_gradient_3, CUSTOM_GRADIENT_3_FILE_NAME)
	if save_result3 != OK: 
		print("Failed to save custom gradient 3")

# Load the state
func load_state():
	# Load each of our stored gradients
	if ResourceLoader.exists(CUSTOM_GRADIENT_1_FILE_NAME):
		var loaded_gradient = ResourceLoader.load(CUSTOM_GRADIENT_1_FILE_NAME)
		if loaded_gradient is CustomGradient:
			custom_gradient_1 = loaded_gradient
		else:
			print("Custom Gradient 1 file is corrupted")
	else:
		custom_gradient_1 = CustomGradient.new()
		custom_gradient_1.make_random()
	
	if ResourceLoader.exists(CUSTOM_GRADIENT_2_FILE_NAME):
		var loaded_gradient = ResourceLoader.load(CUSTOM_GRADIENT_2_FILE_NAME)
		if loaded_gradient is CustomGradient:
			custom_gradient_2 = loaded_gradient
		else:
			print("Custom Gradient 2 file is corrupted")
	else:
		custom_gradient_2 = CustomGradient.new()
		custom_gradient_2.make_random()
	
	if ResourceLoader.exists(CUSTOM_GRADIENT_3_FILE_NAME):
		var loaded_gradient = ResourceLoader.load(CUSTOM_GRADIENT_3_FILE_NAME)
		if loaded_gradient is CustomGradient:
			custom_gradient_3 = loaded_gradient
		else:
			print("Custom Gradient 3 file is corrupted")
	else:
		custom_gradient_3 = CustomGradient.new()
		custom_gradient_3.make_random()
		

# Signal for saying that the custom gradient 1 has changed
signal custom_gradient_1_changed()
	
# Sets the new theme and emits the custom_gradient_1_changed signal
func set_custom_gradient_1(new_custom_gradient: CustomGradient):
	custom_gradient_1 = new_custom_gradient
	if loaded_themes.has(THEME.CUSTOM_1):
		loaded_themes.erase(THEME.CUSTOM_1)
	emit_signal("custom_gradient_1_changed")
	save_state()
	SettingsManager.set_dice_theme(THEME.CUSTOM_1)
	
# Gets the custom gradient 1
func get_custom_gradient_1() -> CustomGradient:
	return custom_gradient_1
	
# Signal for saying that the custom gradient 2 has changed
signal custom_gradient_2_changed()
	
# Sets the new theme and emits the custom_gradient_2_changed signal
func set_custom_gradient_2(new_custom_gradient: CustomGradient):
	custom_gradient_2 = new_custom_gradient
	if loaded_themes.has(THEME.CUSTOM_2):
		loaded_themes.erase(THEME.CUSTOM_2)
	emit_signal("custom_gradient_2_changed")
	save_state()
	SettingsManager.set_dice_theme(THEME.CUSTOM_2)
	
# Gets the custom gradient 2
func get_custom_gradient_2() -> CustomGradient:
	return custom_gradient_2
	
# Signal for saying that the custom gradient 3 has changed
signal custom_gradient_3_changed()
	
# Sets the new theme and emits the custom_gradient_3_changed signal
func set_custom_gradient_3(new_custom_gradient: CustomGradient):
	custom_gradient_3 = new_custom_gradient
	if loaded_themes.has(THEME.CUSTOM_3):
		loaded_themes.erase(THEME.CUSTOM_3)
	emit_signal("custom_gradient_3_changed")
	save_state()
	SettingsManager.set_dice_theme(THEME.CUSTOM_3)
	
# Gets the custom gradient 3
func get_custom_gradient_3() -> CustomGradient:
	return custom_gradient_3
	
# Signal for saying that the random match gradient has changed
signal random_match_gradient_changed()
	
# Randomize the matching random gradient. 
func randomize_random_match():
	if loaded_themes.has(THEME.RANDOM_MATCHING):
		loaded_themes.erase(THEME.RANDOM_MATCHING)

func get_theme_name_from_enum(theme: THEME) -> String:
	match(theme):
		THEME.AGENDER:
			return "agender"
		THEME.AROMANTIC:
			return "aromantic"
		THEME.ASEXUAL:
			return "asexual"
		THEME.BEACH:
			return "beach"
		THEME.BISEXUAL:
			return "bisexual"
		THEME.COMMUNITY_LESBIAN:
			return "community-lesbian"
		THEME.CREAMSICLE:
			return "creamsicle"
		THEME.CUSTOM_1:
			return "custom-1"
		THEME.CUSTOM_2:
			return "custom-2"
		THEME.CUSTOM_3:
			return "custom-3"
		THEME.FIRE:
			return "fire"
		THEME.FOREST:
			return "forest"
		THEME.GENDERFLUID:
			return "genderfluid"
		THEME.GENDERQUEER:
			return "genderqueer"
		THEME.GOLD:
			return "gold"
		THEME.INTERSEX:
			return "intersex"
		THEME.LGBT:
			return "lgbt"
		THEME.LIPSTICK_LESBIAN:
			return "lipstick-lesbian"
		THEME.MINT_CHOCOLATE:
			return "mint-chocolate"
		THEME.NON_BINARY:
			return "non-binary"
		THEME.PANSEXUAL:
			return "pansexual"
		THEME.POLYSEXUAL:
			return "polysexual"
		THEME.RAINBOW:
			return "rainbow"
		THEME.RANDOM:
			return "random"
		THEME.RANDOM_MATCHING:
			return "random-matching"
		THEME.RGB:
			return "rgb"
		THEME.SHERBERT:
			return "sherbert"
		THEME.STEEL:
			return "steel"
		THEME.SUPERMAN:
			return "superman"
		THEME.TRANSGENDER:
			return "transgender"
		THEME.WHITE:
			return "white"
		_:
			return "unknown"

func get_theme_texture(theme: THEME) -> Texture2D:
	# If we already processed our theme and generated the texture, don't regenerate it.
	if loaded_themes.has(theme):
			return loaded_themes[theme]
		
	match theme:
		THEME.FIRE:
			var fire_gradient : CustomGradient = ResourceLoader.load("res://DicePNGs/Gradients/fire.tres")
			loaded_themes[theme] = fire_gradient.generate_gradient_texture_2d()
		THEME.CUSTOM_1:
			loaded_themes[theme] = custom_gradient_1.generate_gradient_texture_2d()
		THEME.CUSTOM_2:
			loaded_themes[theme] = custom_gradient_2.generate_gradient_texture_2d()
		THEME.CUSTOM_3:
			loaded_themes[theme] = custom_gradient_3.generate_gradient_texture_2d()
		THEME.RANDOM:
			var custom_gradient : CustomGradient = CustomGradient.new()
			custom_gradient.make_random()
			return custom_gradient.generate_gradient_texture_2d()
		THEME.RANDOM_MATCHING:
			var custom_gradient : CustomGradient = CustomGradient.new()
			custom_gradient.make_random()
			loaded_themes[theme] = custom_gradient.generate_gradient_texture_2d()
		_:
			var theme_name = get_theme_name_from_enum(theme)
			loaded_themes[theme] = load(str("res://DicePNGs/Gradients/", theme_name, ".png"))
			
	return loaded_themes[theme]

func get_die_image(imageID : int) -> String:
	var die_name = 'unknown-die'
	
	match(imageID):
		DIE_FATE: die_name = "fate"
		DIE_2: die_name = "d2"
		DIE_3: die_name = "d3"
		DIE_4: die_name = "d4"
		DIE_6: die_name = "d6"
		DIE_8: die_name = "d8"
		DIE_10: die_name = "d10"
		DIE_12: die_name = "d12"
		DIE_20: die_name = "d20"
		DIE_100: die_name = "d100"
	
	return str("res://DicePNGs/white/", die_name,".png")
