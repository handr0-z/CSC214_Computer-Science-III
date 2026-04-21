extends MarginContainer

# Node References
@onready var menu: Button = %menubutton
@onready var btn_replay: Button = %btn_replay

# Signals
signal btn_replay_pressed

# Function called when the menu panel is loaded into the scene
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Connect menu button to return to the main menu
	menu.pressed.connect(func() -> void:
		get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
	)

	# Connect replay button to emit replay event
	btn_replay.pressed.connect(func() -> void:
		btn_replay_pressed.emit()
	)

# Function used when the menu button is pressed (fallback handler)
func _on_menubutton_pressed() -> void:
	var tree := get_tree()
	tree.paused = false
	tree.change_scene_to_file("res://scenes/ui/MainMenu.tscn")
