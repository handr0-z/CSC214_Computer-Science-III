extends Bullet
class_name BulletLinear

# Exported Variables (Visible in Inspector)
@export var P_EXPLOSION: PackedScene
@export var explode_damage: float = 8

# Runtime Variables
var explosion: Node2D = null
var direction: Vector2 = Vector2.ZERO

# Function used to initialize bullet with target and range
func initialize(_target, _start_position: Vector2, _max_range: float) -> void:
	# Store travel parameters
	start_position = _start_position
	max_distance = _max_range
	global_position = start_position

	# Linear bullet → only read direction once
	if _target != null and is_instance_valid(_target):
		direction = (_target.global_position - global_position).normalized()
		rotation = direction.angle()
	else:
		# Fallback direction if no target is available
		direction = Vector2.RIGHT

# Function called every frame
func _process(delta: float) -> void:
	var step := speed * delta
	
	# Move bullet in fixed direction
	global_position += direction * step

	# Destroy bullet if it exceeds max travel range
	if global_position.distance_to(start_position) >= max_distance:
		queue_free()
		return

	# Check if any enemy is within hit range this frame
	var enemy_hit: Node = get_enemy_in_hit_range(step)
	if enemy_hit != null:
		hit(enemy_hit)

# Function used to detect enemies within bullet movement range
func get_enemy_in_hit_range(step: float):
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy and enemy.global_position.distance_to(global_position) <= step:
			return enemy
	return null

# Function used to spawn explosion on hit
func create_explosion() -> void:
	if P_EXPLOSION == null:
		return

	explosion = P_EXPLOSION.instantiate()
	explosion.damage = explode_damage

	get_parent().add_child(explosion)
	explosion.global_position = global_position

# Function used to apply damage to an enemy
func hit(enemy) -> void:
	# Spawn explosion first
	create_explosion()
	
	# Apply damage if enemy supports it
	if enemy and enemy.has_method("damage"):
		enemy.damage(damage)
	
	# Call parent cleanup logic (queue_free)
	super.hit(enemy)
