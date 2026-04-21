extends MarginContainer

@onready var menu: Button = %menubutton
@onready var btn_next: Button = %btnnext    # 👈 renamed

signal next_pressed

func _ready() -> void:
	# Allow this popup to work while paused
	process_mode = Node.PROCESS_MODE_ALWAYS

	btn_next.pressed.connect(
		func() -> void:
			next_pressed.emit()
	)

func _on_menubutton_pressed() -> void:
	var tree := get_tree()
	tree.paused = false
	tree.change_scene_to_file("res://scenes/ui/MainMenu.tscn")
