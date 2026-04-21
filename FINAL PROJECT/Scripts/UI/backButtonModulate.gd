extends Button

func _ready():
	modulate = Color(0.408, 0.773, 0.859, 1.0)

func _on_mouse_entered():
	modulate = Color(1.15, 1.15, 1.15, 1)  # brighter

func _on_mouse_exited():
	modulate = Color(0.408, 0.773, 0.859, 1.0)  # reset
