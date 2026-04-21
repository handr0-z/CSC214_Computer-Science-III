class_name MainMenu
extends Control

func _on_start_button_pressed() -> void:
	# Go to your level select, or straight to the game
	get_tree().change_scene_to_file("res://scenes/ui/EnterName.tscn")
	# Or:
	# get_tree().change_scene_to_file("res://main.tscn")

func _on_load_button_pressed() -> void:
	# You can make this do something later; for now just reuse Start
	get_tree().change_scene_to_file("res://scenes/ui/LevelScreen.tscn")

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/SettingsMenu.tscn")

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/CreditsScreen.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
