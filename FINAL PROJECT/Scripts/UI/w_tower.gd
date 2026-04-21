@tool
extends MarginContainer

# Node References
@onready var sub_viewport: SubViewport = %SubViewport
@onready var lab_cost: Label = %lab_cost

# Exported Variables
@export var P_TOWER: PackedScene:
	set(value):
		P_TOWER = value
		if sub_viewport:
			update_display()

# Runtime Variables
var tower: Node = null

# Signals
signal released

# Function called when this shop widget enters the scene
func _ready() -> void:
	for c in sub_viewport.get_children():
		c.queue_free()

	update_display()

	if not is_connected("gui_input", _on_gui_input):
		connect("gui_input", _on_gui_input)

# Function used to detect mouse input on the shop button
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.is_released():
		released.emit()

# Function used to check if the preview tower has a "cost" property
func _tower_has_cost() -> bool:
	if not tower:
		return false

	for p in tower.get_property_list():
		if p.name == "cost":
			return true

	return false

# Function used to create or update the tower preview inside the viewport
func update_display() -> void:
	if not P_TOWER:
		return

	if tower and is_instance_valid(tower):
		tower.queue_free()

	tower = P_TOWER.instantiate()
	tower.set_process(false)
	tower.set_physics_process(false)

	sub_viewport.add_child(tower)

	tower.position = Vector2(32, 32)
	tower.scale = Vector2.ONE * 1.75

	if _tower_has_cost():
		lab_cost.text = str(tower.cost)
	else:
		lab_cost.text = "?"

# Function used to determine if the player can afford this tower
func can_place_tower(coin: int) -> bool:
	if not tower:
		return false

	var cost: int = tower.cost if _tower_has_cost() else 0
	return coin >= cost

# Function used to update the cost display color based on player gold
func update_cost_display(coin: int) -> void:
	if not tower:
		return

	var cost: int = tower.cost if _tower_has_cost() else 0
	lab_cost.modulate = Color.RED if coin < cost else Color.WHITE
