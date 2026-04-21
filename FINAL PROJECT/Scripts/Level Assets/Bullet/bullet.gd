extends Node2D
class_name Bullet

# Exported Variables (Visible in Inspector)
@export var damage: float = 10
@export var speed: float = 500
@export var dead_time: float = 3

# Runtime Variables
var start_position: Vector2
var max_distance: float = 0
var target = null    # Left untyped for compatibility

# Function called when bullet is loaded onto scene
func _ready() -> void:
	# Setup lifetime timer for bullet
	$Timer.wait_time = dead_time
	if not $Timer.timeout.is_connected(_on_timer_timeout):
		$Timer.timeout.connect(_on_timer_timeout)
	
	# Connect collision detection
	if not $Area2D.area_entered.is_connected(_on_area_entered):
		$Area2D.area_entered.connect(_on_area_entered)

# Function used to initialize bullet with target and range
func initialize(new_target, origin_position: Vector2, max_range: float):
	target = new_target
	start_position = origin_position
	max_distance = max_range
	global_position = origin_position

# Function called every frame
func _process(delta: float) -> void:
	# Make collision area match bullet rotation
	$Area2D.rotation = rotation

	# Destroy bullet if it exceeds max travel range
	if global_position.distance_to(start_position) >= max_distance:
		queue_free()
		return

	# Destroy bullet if target is missing or invalid
	if target == null or not is_instance_valid(target):
		queue_free()
		return

	# Move bullet toward target
	var direction = (target.global_position - global_position).normalized()
	global_position += direction * speed * delta
	rotation = direction.angle()

# Function used to apply damage to an enemy
func hit(enemy) -> void:
	if enemy:
		enemy.damage(damage)
	queue_free()

# Function called when bullet collides with an Area2D
func _on_area_entered(area: Area2D) -> void:
	if area.owner and area.owner.has_method("damage"):
		hit(area.owner)

# Function called when lifetime timer runs out
func _on_timer_timeout() -> void:
	queue_free()
