extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().size_changed.connect(SettingsManager.trigger_reconfigure)
