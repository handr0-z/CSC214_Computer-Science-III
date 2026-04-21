extends Control

# Node References
@onready var btn_level1: Button = $MarginContainer/MarginContainer/HBoxContainer/Level1
@onready var btn_level2: Button = $MarginContainer/MarginContainer/HBoxContainer/Level2
@onready var btn_level3: Button = $MarginContainer/MarginContainer/HBoxContainer/Level3

# Function called when the menu loads
func _ready() -> void:
	_update_level_buttons()

# Function used to update level button states based on unlock progress
func _update_level_buttons() -> void:
	btn_level1.disabled = not GlobalGameState.is_level_unlocked(1)
	btn_level2.disabled = not GlobalGameState.is_level_unlocked(2)
	btn_level3.disabled = not GlobalGameState.is_level_unlocked(3)

	# Update locked indicators
	btn_level2.text = "2(Locked)" if btn_level2.disabled else "2"
	btn_level3.text = "3(Locked)" if btn_level3.disabled else "3"

# Function used to navigate back to the main menu
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")

# Function used to load Level 1
func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level/Level1.tscn")

# Function used to load Level 2
func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level/Level2.tscn")

# Function used to load Level 3
func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level/Level3.tscn")
