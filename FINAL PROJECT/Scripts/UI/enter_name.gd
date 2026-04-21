extends Control

@onready var name_box: LineEdit = $MarginContainer/MarginContainer/VBoxContainer/LineEdit

func _on_Confirm_pressed() -> void:
	var player_name := name_box.text.strip_edges()

	if player_name == "":
		player_name = "Player"
	GlobalGameState.player_name = player_name
	get_tree().change_scene_to_file("res://scenes/ui/LevelScreen.tscn")

func _ready():
	$MarginContainer/MarginContainer/VBoxContainer/Confirm.pressed.connect(_on_Confirm_pressed)
