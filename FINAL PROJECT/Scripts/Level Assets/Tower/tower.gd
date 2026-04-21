extends Node2D
class_name Tower

# Signals
signal tower_selected(tower)

# Node References
@onready var area_2d: Area2D = $Area2D
@onready var fort: Node2D = $fort
@onready var range_indicator: Node2D = $RangeIndicator
@onready var click_area: Area2D = $ClickArea

# Exported Variables (Visible in Inspector)
@export var cost: int = 30

# Base Stat Values
@export var damage: int = 10
@export var damage_increase: int = 4
@export var damage_cost: int = 25

@export var attack_speed: float = 1.0
@export var speed_increase: float = 0.2
@export var speed_cost: int = 20

@export var range: float = 80
@export var range_increase: float = 30
@export var range_cost: int = 30

@export var p_bullet: PackedScene
@export var bullet_count: int = 1
@export var rotation_speed: float = 8.0

# Upgrade Levels
var damage_level: int = 0
var speed_level: int = 0
var range_level: int = 0

var level: int:
	get:
		return damage_level + speed_level + range_level

# Runtime Variables
var current_cd: float = 0
var current_bullet_count: int
var enemies: Array = []

# Function called when tower enters the scene
func _ready() -> void:
	if not click_area.is_connected("input_event", _on_click_area_event):
		click_area.connect("input_event", _on_click_area_event)

	_update_range_shapes()
	range_indicator.hide_range()

# Function called manually to prepare detection and starting values
func initialize() -> void:
	area_2d.area_entered.connect(_on_area_entered)
	area_2d.area_exited.connect(_on_area_exit)

	for area in area_2d.get_overlapping_areas():
		enemies.append(area.owner)

	current_bullet_count = bullet_count

# Main update loop
func _process(delta: float) -> void:
	# Remove invalid enemies
	enemies = enemies.filter(func(e):
		return e != null and is_instance_valid(e) and not e.is_queued_for_deletion()
	)

	if enemies.is_empty():
		return

	# Handle attack cooldown
	if current_cd > 0:
		current_cd -= delta
	else:
		_attack_enemy()

	# Rotate turret toward first enemy
	var target_pos = enemies[0].global_position
	var desired_angle = fort.global_position.angle_to_point(target_pos)
	fort.rotation = lerp_angle(fort.rotation, desired_angle, rotation_speed * delta)

# Effective stat getters
func get_damage() -> float:
	return damage + damage_level * damage_increase

func get_cooldown() -> float:
	var effective_speed = attack_speed + speed_level * speed_increase
	return 1.0 / effective_speed

func get_range() -> float:
	return range + range_level * range_increase

# Upgrade functions
func upgrade_damage() -> bool:
	if damage_level < 3:
		damage_level += 1
		return true
	return false

func upgrade_speed() -> bool:
	if speed_level < 3:
		speed_level += 1
		return true
	return false

func upgrade_range() -> bool:
	if range_level < 3:
		range_level += 1
		_update_range_shapes()
		return true
	return false

# Updates collision shapes and range indicator after upgrading range
func _update_range_shapes() -> void:
	var new_r = get_range()

	$ClickArea/CollisionShape2D.shape.radius = new_r
	$Area2D/CollisionShape2D.shape.radius = new_r
	range_indicator.radius = new_r

# Called when an enemy enters tower range
func _on_area_entered(area: Area2D) -> void:
	if area.owner:
		enemies.append(area.owner)

# Called when an enemy leaves tower range
func _on_area_exit(area: Area2D) -> void:
	if area.owner:
		enemies.erase(area.owner)

# Attack cycle logic
func _attack_enemy() -> void:
	if enemies.is_empty():
		return

	if current_bullet_count > 0:
		_spawn_bullet()
	else:
		current_bullet_count = bullet_count
		current_cd = get_cooldown()

# Spawns a bullet toward the nearest enemy
func _spawn_bullet() -> void:
	enemies = enemies.filter(func(e):
		return e != null and is_instance_valid(e) and not e.is_queued_for_deletion()
	)

	if enemies.is_empty():
		return

	var bullet = p_bullet.instantiate()
	bullet.damage = get_damage()
	add_child(bullet)

	var _is_linear := bullet is BulletLinear

	# Linear bullets → lock direction on spawn
	bullet.initialize(
		enemies[0],
		global_position,
		get_range()
	)

	current_bullet_count -= 1
	$audio_explosion.play()

# Handles clicking tower to open upgrade UI
func _on_click_area_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("tower_selected", self)

# Shows the tower's range indicator
func select() -> void:
	range_indicator.show_range()

# Hides the tower's range indicator
func deselect() -> void:
	range_indicator.hide_range()
