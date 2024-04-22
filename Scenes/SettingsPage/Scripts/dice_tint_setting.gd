extends CollapsibleSettingBase
class_name DiceTintSetting

@onready var color_picker : ColorPicker = $TopLevelContainer/CollapsibleContainer/CollapsibleSection/ColorPicker

const DIE_TINT_LABEL_TEXT : String = "Tint - "

var known_colors : Dictionary = Dictionary({
	Color.ALICE_BLUE: "Alice Blue" ,
	Color.ANTIQUE_WHITE: "Antique White" ,
	Color.AQUAMARINE: "Aquamarine" ,
	Color.AZURE: "Azure" ,
	Color.BEIGE: "Beige" ,
	Color.BISQUE: "Bisque" ,
	Color.BLACK: "Black",
	Color.BLANCHED_ALMOND: "Blanched Almond" ,
	Color.BLUE: "Blue" ,
	Color.BLUE_VIOLET: "Blue Violet" ,
	Color.BROWN: "Brown" ,
	Color.BURLYWOOD: "Burlywood" ,
	Color.CADET_BLUE: "Cadet Blue" ,
	Color.CHARTREUSE: "Chartreuse" ,
	Color.CHOCOLATE: "Chocolate" ,
	Color.CORAL: "Coral" ,
	Color.CORNFLOWER_BLUE: "Cornflower Blue" ,
	Color.CORNSILK: "Cornsilk" ,
	Color.CRIMSON: "Crimson" ,
	Color.CYAN: "Cyan" ,
	Color.DARK_BLUE: "Dark Blue" ,
	Color.DARK_CYAN: "Dark Cyan" ,
	Color.DARK_GOLDENROD: "Dark Goldenrod" ,
	Color.DARK_GRAY: "Dark Gray" ,
	Color.DARK_GREEN: "Dark Green" ,
	Color.DARK_KHAKI: "Dark Khaki" ,
	Color.DARK_MAGENTA: "Dark Magenta" ,
	Color.DARK_OLIVE_GREEN: "Dark Olive Green" ,
	Color.DARK_ORANGE: "Dark Orange" ,
	Color.DARK_ORCHID: "Dark Orchid" ,
	Color.DARK_RED: "Dark Red" ,
	Color.DARK_SALMON: "Dark Red" ,
	Color.DARK_SEA_GREEN: "Dark Sea Green" ,
	Color.DARK_SLATE_BLUE: "Dark Slate Green" ,
	Color.DARK_SLATE_GRAY: "Dark Slate Gray" ,
	Color.DARK_TURQUOISE: "Dark Turquoise" ,
	Color.DARK_VIOLET: "Dark Violet" ,
	Color.DEEP_PINK: "Deep Pink" ,
	Color.DEEP_SKY_BLUE: "Deep Sky Blue" ,
	Color.DIM_GRAY: "Dim Gray" ,
	Color.DODGER_BLUE: "Dodger Blue" ,
	Color.FIREBRICK: "Firebrick" ,
	Color.FLORAL_WHITE: "Floral White" ,
	Color.FOREST_GREEN: "Forest Green" ,
	Color.FUCHSIA: "Fuchsia" ,
	Color.GAINSBORO: "Gainsboro" ,
	Color.GHOST_WHITE: "Ghost White" ,
	Color.GOLD: "Gold" ,
	Color.GOLDENROD: "Goldenrod" ,
	Color.GRAY: "Gray" ,
	Color.GREEN: "Green" ,
	Color.GREEN_YELLOW: "Green Yellow" ,
	Color.HONEYDEW: "Honeydew" ,
	Color.HOT_PINK: "Hot Pink" ,
	Color.INDIAN_RED: "Indian Red" ,
	Color.INDIGO: "Indigo" ,
	Color.IVORY: "Ivory" ,
	Color.KHAKI: "Khaki" ,
	Color.LAVENDER: "Lavender" ,
	Color.LAVENDER_BLUSH: "Lavender Blush" ,
	Color.LAWN_GREEN: "Lawn Green" ,
	Color.LEMON_CHIFFON: "Lemon Chiffon" ,
	Color.LIGHT_BLUE: "Light Blue" ,
	Color.LIGHT_CORAL: "Light Coral" ,
	Color.LIGHT_CYAN: "Light Cyan" ,
	Color.LIGHT_GOLDENROD: "Light Goldenrod" ,
	Color.LIGHT_GRAY: "Light Gray" ,
	Color.LIGHT_GREEN: "Light Green" ,
	Color.LIGHT_PINK: "Light Pink" ,
	Color.LIGHT_SALMON: "Light Salmon" ,
	Color.LIGHT_SEA_GREEN: "Light Sea Green" ,
	Color.LIGHT_SKY_BLUE: "Light Sky Blue" ,
	Color.LIGHT_SLATE_GRAY: "Light Slate Gray" ,
	Color.LIGHT_STEEL_BLUE: "Light Steel Blue" ,
	Color.LIGHT_YELLOW: "Light Yellow" ,
	Color.LIME_GREEN: "Lime Green" ,
	Color.LINEN: "Linen" ,
	Color.MAROON: "Maroon" ,
	Color.MEDIUM_AQUAMARINE: "Medium Aquamarine" ,
	Color.MEDIUM_BLUE: "Medium Blue" ,
	Color.MEDIUM_ORCHID: "Medium Orchid" ,
	Color.MEDIUM_PURPLE: "Medium Purple" ,
	Color.MEDIUM_SEA_GREEN: "Medium Sea Green" ,
	Color.MEDIUM_SLATE_BLUE: "Medium Slate Blue" ,
	Color.MEDIUM_SPRING_GREEN: "Medium Spring Green" ,
	Color.MEDIUM_TURQUOISE: "Medium Turquoise" ,
	Color.MEDIUM_VIOLET_RED: "Medium Violet Red" ,
	Color.MIDNIGHT_BLUE: "Midnight Blue" ,
	Color.MINT_CREAM: "Mint Cream" ,
	Color.MISTY_ROSE: "Misty Rose" ,
	Color.MOCCASIN: "Moccasin" ,
	Color.NAVAJO_WHITE: "Navajo White" ,
	Color.NAVY_BLUE: "Navy Blue" ,
	Color.OLD_LACE: "Old Lace" ,
	Color.OLIVE: "Olive" ,
	Color.OLIVE_DRAB: "Olive Drab" ,
	Color.ORANGE: "Orange" ,
	Color.ORANGE_RED: "Orange Red" ,
	Color.ORCHID: "Orchid" ,
	Color.PALE_GOLDENROD: "Pale Goldenrod" ,
	Color.PALE_GREEN: "Pale Green" ,
	Color.PALE_TURQUOISE: "Pale Turquoise" ,
	Color.PALE_VIOLET_RED: "Pale Violet Red" ,
	Color.PAPAYA_WHIP: "Papaya Whip" ,
	Color.PEACH_PUFF: "Peach Puff" ,
	Color.PERU: "Peru" ,
	Color.PINK: "Pink" ,
	Color.PLUM: "Plum" ,
	Color.POWDER_BLUE: "Powder Blue" ,
	Color.PURPLE: "Purple" ,
	Color.REBECCA_PURPLE: "Rebecca Purple" ,
	Color.RED: "Red" ,
	Color.ROSY_BROWN: "Rosy Brown" ,
	Color.ROYAL_BLUE: "Royal Blue" ,
	Color.SADDLE_BROWN: "Saddle Brown" ,
	Color.SALMON: "Salmon" ,
	Color.SANDY_BROWN: "Sandy Brown" ,
	Color.SEA_GREEN: "Sea Green" ,
	Color.SEASHELL: "Seashell" ,
	Color.SIENNA: "Sienna" ,
	Color.SILVER: "Silver" ,
	Color.SKY_BLUE: "Sky Blue" ,
	Color.SLATE_BLUE: "Slate Blue" ,
	Color.SLATE_GRAY: "Slate Gray" ,
	Color.SNOW: "Snow" ,
	Color.SPRING_GREEN: "Spring Green" ,
	Color.STEEL_BLUE: "Steel Blue" ,
	Color.TAN: "Tan" ,
	Color.TEAL: "Teal" ,
	Color.THISTLE: "Thistle" ,
	Color.TOMATO: "Tomato" ,
	Color.TURQUOISE: "Turquoise" ,
	Color.VIOLET: "Violet" ,
	Color.WEB_GRAY: "Web Gray" ,
	Color.WEB_GREEN: "Web Green" ,
	Color.WEB_MAROON: "Web Maroon" ,
	Color.WEB_PURPLE: "Web Purple" ,
	Color.WHEAT: "Wheat" ,
	Color.WHITE: "White" ,
	Color.WHITE_SMOKE: "White Smoke" ,
	Color.YELLOW: "Yellow",
	Color.YELLOW_GREEN: "Yellow Green",
})

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	SettingsManager.dice_tint_color_changed.connect(reconfigure_sliders)
	reconfigure_sliders()
	
# Grabs the offical value from the settings manager and sets the size
func reconfigure_sliders() -> void:
	var new_color: Color = SettingsManager.get_dice_tint_color()
	color_picker.color = new_color
	set_title()
	show_hide_reset_button()
	
func get_closest_known_color(given_color: Color) -> Color:
	var given_color_vec: Vector3 = Vector3(given_color.r, given_color.g, given_color.b)
	# Give ourselves a known good answer.
	var closest_color: Color = Color.ALICE_BLUE
	var closest_distance: float = INF
	
	for known_color : Color in known_colors.keys():
		var possible_color_vec : Vector3 = Vector3(known_color.r, known_color.g, known_color.b)
		var possible_distance : float = given_color_vec.distance_to(possible_color_vec)
		if possible_distance < closest_distance:
			closest_color = known_color
			closest_distance = possible_distance
	
	return closest_color
	
func inner_get_title() -> String:
	var current_color : Color = SettingsManager.get_dice_tint_color()
	var closest_color : Color = get_closest_known_color(current_color)
	var closest_color_name : String = known_colors[closest_color]
	var alpha_percent_string : String = StringHelper.decimal_to_string(current_color.a * 100, 0)
	var possible_squigle : String = ""
	# If we aren't really close to that color put the squigle in.
	if Vector3(current_color.r, current_color.g, current_color.b).distance_to(Vector3(closest_color.r, closest_color.g, closest_color.b)) > 0.05:
		possible_squigle = "~"
	return str(DIE_TINT_LABEL_TEXT, possible_squigle, closest_color_name, " - ", alpha_percent_string, "%")

# Method for inherited class to get the minimum height of the collapsible section
func inner_get_collapsible_section_minimum_height() -> int:
	return int(color_picker.size.y)
	
# Method for inherited class to implement if the reset button should be shown
func inner_should_show_reset_button() -> bool:
	return SettingsManager.get_dice_tint_color() != SettingsManager.DICE_TINT_COLOR_DEFAULT

# Method for inherited class to respond to reset being pressed
func inner_reset_button_pressed() -> void:
	SettingsManager.set_dice_tint_color(SettingsManager.DICE_TINT_COLOR_DEFAULT)

func _on_color_picker_color_changed(color : Color) -> void:
	SettingsManager.set_dice_tint_color(color)
	emit_signal("setting_changed")
