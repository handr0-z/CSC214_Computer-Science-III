extends Node2D

# Node References
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D

# Exported Variables (Visible in Inspector)
@export var damage: float = 10

# Runtime Variables
var has_exploded := false

# Signals
signal exploded

# Function called when explosion node is loaded onto scene
func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

# Function called when explosion animation finishes
func _on_animation_finished() -> void:
	# Ensure explosion triggers only once
	if has_exploded:
		return
	has_exploded = true

	# Deal damage to all enemies within the explosion area
	for area in area_2d.get_overlapping_areas():
		if area.owner is Enemy:
			area.owner.damage(damage)

	# Emit explosion event
	exploded.emit()

	# Remove explosion after it finishes
	queue_free()
