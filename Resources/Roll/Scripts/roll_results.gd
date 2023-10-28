extends Resource
class_name RollResults

# Each of these maps is of type <String, Array<Variant>>
# The map string should be in the form: JSON.stringify(die)
@export var m_roll_results : Dictionary = {}
@export var m_dropped_rolls : Dictionary = {}
@export var m_rerolled_rolls : Dictionary = {}

@export var m_struck_roll_results : Dictionary = {}
@export var m_struck_dropped_rolls : Dictionary = {}
@export var m_struck_rerolled_rolls : Dictionary = {}

# The roll properties of each die in the form <String, RollProperties>
# Use the same keys as above for access.
@export var m_roll_properties : Dictionary = {}

func get_merged_keys() -> Array[String]:
	var returnKeys = {}
	returnKeys.merge(m_roll_results)
	returnKeys.merge(m_dropped_rolls)
	returnKeys.merge(m_rerolled_rolls)
	returnKeys.merge(m_struck_roll_results)
	returnKeys.merge(m_struck_dropped_rolls)
	returnKeys.merge(m_struck_rerolled_rolls)
	returnKeys.merge(m_roll_properties)
	return returnKeys.keys()

func sort_all_descending():
	sort_map_lists_decending(m_roll_results)
	sort_map_lists_decending(m_dropped_rolls)
	sort_map_lists_decending(m_rerolled_rolls)
	sort_map_lists_decending(m_struck_roll_results)
	sort_map_lists_decending(m_struck_dropped_rolls)
	sort_map_lists_decending(m_struck_rerolled_rolls)

func sort_all_ascending():
	sort_map_lists_ascending(m_roll_results)
	sort_map_lists_ascending(m_dropped_rolls)
	sort_map_lists_ascending(m_rerolled_rolls)
	sort_map_lists_ascending(m_struck_roll_results)
	sort_map_lists_ascending(m_struck_dropped_rolls)
	sort_map_lists_ascending(m_struck_rerolled_rolls)

func sort_map_lists_ascending(roll_map : Dictionary):
	for roll_list in roll_map.values():
		roll_list.sort_custom(func(a,b): return a < b);

func sort_map_lists_decending(roll_map : Dictionary):
	for roll_list in roll_map.values():
		roll_list.sort_custom(func(a,b): return a > b);
