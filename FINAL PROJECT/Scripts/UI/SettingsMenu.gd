class_name SettingsMenu
extends Control

signal settings_saved

var difficulty_level: int = 1
var music_volume: float = 1.0
var sfx_volume: float = 1.0

func _ready():
	pass

func _on_difficulty_changed(value: int):
	difficulty_level = value

func _on_music_volume_changed(value: float):
	music_volume = value

func _on_sfx_volume_changed(value: float):
	sfx_volume = value

func _on_save_pressed():
	emit_signal("settings_saved")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
