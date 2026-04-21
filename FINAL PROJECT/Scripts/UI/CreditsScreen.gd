class_name CreditsScreen
extends Control
# Displays our names after final level or in main menu

func _ready():
	pass

func play_credits():
	pass  # TODO: Scroll text animation or fade-in names

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
