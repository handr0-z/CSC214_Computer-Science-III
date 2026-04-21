extends Area2D

# Signals
signal clicked(tower)

# Function called when node is added to the scene
func _ready() -> void:
	# Allow this Area2D to receive mouse click input
	input_pickable = true

# Function called when an input event occurs on this Area2D
func _input_event(_viewport, event, _shape_idx) -> void:
	# Detect left mouse click
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		# Get parent (expected to be a Tower)
		var tower = get_parent()

		# Emit tower_selected signal from Tower if valid
		if tower:
			tower.emit_signal("tower_selected", tower)
