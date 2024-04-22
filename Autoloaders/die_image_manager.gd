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

# Supported themes. When this is updated, update the dict below.
enum THEME {
	AGENDER,
	AROMANTIC,
	ASEXUAL,
	BEACH,
	BISEXUAL,
	COMMUNITY_LESBIAN,
	CREAMSICLE,
	CUSTOM,
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

# Dictionary for getting a readable name from the theme name
const THEME_TO_NAME_DICT : Dictionary = {
	THEME.AGENDER: "Agender",
	THEME.AROMANTIC: "Aromantic",
	THEME.ASEXUAL: "Asexual",
	THEME.BEACH: "Beach",
	THEME.BISEXUAL: "Bisexual",
	THEME.COMMUNITY_LESBIAN: "Community Lesbian",
	THEME.CREAMSICLE: "Creamsicle",
	THEME.CUSTOM: "Custom",
	THEME.FIRE: "Fire",
	THEME.FOREST: "Forest",
	THEME.GENDERFLUID: "Genderfluid",
	THEME.GENDERQUEER: "Genderqueer",
	THEME.GOLD: "Gold",
	THEME.INTERSEX: "Intersex",
	THEME.LGBT: "LGBT",
	THEME.LIPSTICK_LESBIAN: "Lipstick Lesbian",
	THEME.MINT_CHOCOLATE: "Mint Chocolate",
	THEME.NON_BINARY: "Non Binary",
	THEME.PANSEXUAL: "Pansexual",
	THEME.POLYSEXUAL: "Polysexual",
	THEME.RAINBOW: "Rainbow",
	THEME.RANDOM: "Random",
	THEME.RANDOM_MATCHING: "Random Matching",
	THEME.RGB: "RGB",
	THEME.SHERBERT: "Sherbert",
	THEME.STEEL: "Steel",
	THEME.SUPERMAN: "Superman",
	THEME.TRANSGENDER: "Transgender",
	THEME.WHITE: "White",
}

# Dictionary for converting from a name to a theme.
# Items are stored in snake_case.
var NAME_TO_THEME_DICT : Dictionary = {}

const CUSTOM_GRADIENT_FILE_NAME : StringName = "user://custom_gradient.tres"
var custom_gradient : CustomGradient = CustomGradient.new()

var loaded_themes : Dictionary = {}

func _ready() -> void:
	setup_name_to_theme_dict()
	load_state()
	
func save_state() -> void:
	var save_result : Error = ResourceSaver.save(custom_gradient, CUSTOM_GRADIENT_FILE_NAME)
	if save_result != OK: 
		print("Failed to save custom gradient")

# Load the state
func load_state() -> void:
	# Load each of our stored gradients
	if ResourceLoader.exists(CUSTOM_GRADIENT_FILE_NAME):
		var loaded_gradient : Resource = ResourceLoader.load(CUSTOM_GRADIENT_FILE_NAME)
		if loaded_gradient is CustomGradient:
			custom_gradient = loaded_gradient
		else:
			print("Custom Gradient file is corrupted")
	else:
		custom_gradient = CustomGradient.new()
		custom_gradient.make_random()
		
# Setup the name to theme dict off of the theme to name dict
# String names are stored in snake_case
func setup_name_to_theme_dict() -> void:
	for theme_key : THEME in THEME_TO_NAME_DICT.keys():
		var theme_name : String = THEME_TO_NAME_DICT[theme_key]
		theme_name = theme_name.to_snake_case()
		NAME_TO_THEME_DICT[theme_name] = theme_key

# Signal for saying that the custom gradient has changed
signal custom_gradient_changed()
	
# Sets the new theme and emits the custom_gradient_changed signal
func set_custom_gradient(new_custom_gradient: CustomGradient) -> void:
	custom_gradient = new_custom_gradient
	if loaded_themes.has(THEME.CUSTOM):
		loaded_themes.erase(THEME.CUSTOM)
	emit_signal("custom_gradient_changed")
	save_state()
	SettingsManager.set_dice_theme(THEME.CUSTOM)
	
# Gets the custom gradient
func get_custom_gradient() -> CustomGradient:
	return custom_gradient
	
# Signal for saying that the random match gradient has changed
signal random_match_gradient_changed()
	
# Randomize the matching random gradient. 
func randomize_random_match() -> void:
	if loaded_themes.has(THEME.RANDOM_MATCHING):
		loaded_themes.erase(THEME.RANDOM_MATCHING)

# Gets the theme name from the given theme
# Returns white if given unknown theme
func get_theme_name_from_enum(theme: THEME) -> String:
	if THEME_TO_NAME_DICT.has(theme):
		return THEME_TO_NAME_DICT[theme]
		
	return THEME_TO_NAME_DICT[THEME.WHITE]
	

# Gets the theme from the given name.
# If incorrect theme name is given returns WHITE
func get_theme_enum_from_name(theme_name: String) -> THEME:
	if NAME_TO_THEME_DICT.has(theme_name):
		return NAME_TO_THEME_DICT[theme_name]
		
	var snake_cased_name : String = theme_name.to_snake_case()
	
	if NAME_TO_THEME_DICT.has(snake_cased_name):
		return NAME_TO_THEME_DICT[snake_cased_name]
		
	return THEME.WHITE

func get_theme_texture(theme: THEME) -> Texture2D:
	# If we already processed our theme and generated the texture, don't regenerate it.
	if loaded_themes.has(theme):
			return loaded_themes[theme]
		
	match theme:
		THEME.FIRE:
			var fire_gradient : CustomGradient = ResourceLoader.load("res://DicePNGs/Gradients/fire.tres")
			loaded_themes[theme] = fire_gradient.generate_gradient_texture_2d()
		THEME.CUSTOM:
			loaded_themes[theme] = custom_gradient.generate_gradient_texture_2d()
		THEME.RANDOM:
			var random_gradient : CustomGradient = CustomGradient.new()
			random_gradient.make_random()
			return random_gradient.generate_gradient_texture_2d()
		THEME.RANDOM_MATCHING:
			var random_gradient : CustomGradient = CustomGradient.new()
			random_gradient.make_random()
			loaded_themes[theme] = random_gradient.generate_gradient_texture_2d()
		_:
			var theme_name : String = get_theme_name_from_enum(theme)
			theme_name = theme_name.to_snake_case()
			loaded_themes[theme] = load(str("res://DicePNGs/Gradients/", theme_name, ".png"))
			
	return loaded_themes[theme]

func get_die_image(imageID : int) -> String:
	var die_name : String = 'unknown-die'
	
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
