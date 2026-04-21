extends Node2D
class_name RangeIndicator

# Exported Variables (Visible in Inspector)
@export var radius: float = 150
@export var color: Color = Color(1.0, 1.0, 1.0, 0.15)

# Runtime Variables
var visible_circle := false

# Function that draws the range indicator when needed
func _draw() -> void:
	if visible_circle:
		draw_circle(Vector2.ZERO, radius, Color(0.402, 0.496, 0.649, 0.2))

# Function that enables the range indicator
func show_range() -> void:
	visible_circle = true
	queue_redraw()

# Function that hides the range indicator
func hide_range() -> void:
	visible_circle = false
	queue_redraw()
