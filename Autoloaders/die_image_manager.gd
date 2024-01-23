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
	RGB,
	SHERBERT,
	STEEL,
	SUPERMAN,
	TRANSGENDER,
	WHITE
}

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
	var theme_name = get_theme_name_from_enum(theme)
	return load(str("res://DicePNGs/Gradients/", theme_name, ".png"))

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
