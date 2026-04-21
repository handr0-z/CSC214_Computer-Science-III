class_name HUD
extends Control
# Displays player stats during gameplay (health, gold, wave, etc.)

@onready var health_label: Label = $HealthLabel
@onready var gold_label: Label = $GoldLabel
@onready var wave_label: Label = $WaveLabel

func _ready():
	pass  # TODO: Initialize UI values on game start

func update_health(value: int):
	pass  # TODO: Update health text

func update_gold(value: int):
	pass  # TODO: Update gold text

func update_wave(current: int, total: int):
	pass  # TODO: Display wave progress
