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

var loaded_themes : Dictionary = {}

func _ready():
	randomize_random_match()

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
			
func randomize_random_match():
	var custom_gradient : CustomGradient = preload("res://DicePNGs/Gradients/random-match.tres")
	custom_gradient.make_random()
			
func get_theme_texture(theme: THEME) -> Texture2D:
	# If we already processed our theme and generated the texture, don't regenerate it.
	if loaded_themes.has(theme) && theme != THEME.RANDOM:
		return loaded_themes[theme]
		
	match theme:
		THEME.FIRE:
			var fire_gradient : CustomGradient = preload("res://DicePNGs/Gradients/fire.tres")
			loaded_themes[theme] = fire_gradient.generate_gradient_texture_2d()
		THEME.CUSTOM_1:
			var custom_gradient : CustomGradient = preload("res://DicePNGs/Gradients/custom-1.tres")
			custom_gradient.make_random()
			loaded_themes[theme] = custom_gradient.generate_gradient_texture_2d()
		THEME.CUSTOM_2:
			var custom_gradient : CustomGradient = preload("res://DicePNGs/Gradients/custom-2.tres")
			custom_gradient.make_random()
			loaded_themes[theme] = custom_gradient.generate_gradient_texture_2d()
		THEME.CUSTOM_3:
			var custom_gradient : CustomGradient = preload("res://DicePNGs/Gradients/custom-3.tres")
			custom_gradient.make_random()
			loaded_themes[theme] = custom_gradient.generate_gradient_texture_2d()
		THEME.RANDOM:
			var custom_gradient : CustomGradient = preload("res://DicePNGs/Gradients/random.tres")
			custom_gradient.make_random()
			return custom_gradient.generate_gradient_texture_2d()
		THEME.RANDOM_MATCHING:
			var custom_gradient : CustomGradient = preload("res://DicePNGs/Gradients/random-match.tres")
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
