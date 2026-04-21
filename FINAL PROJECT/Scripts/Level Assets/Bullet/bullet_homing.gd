extends Bullet
class_name BulletHoming

# Function called every frame
func _process(delta):
	# Destroy bullet if target is missing or invalid
	if target == null or not is_instance_valid(target):
		queue_free()
		return

	# Move toward target
	var direction = (target.global_position - global_position).normalized()
	rotation = direction.angle()
	position += direction * speed * delta

	# Destroy bullet if target is queued for deletion
	if target.is_queued_for_deletion():
		queue_free()

# Function called when lifetime timer runs out
func _on_timer_timeout() -> void:
	# Ensure bullet is not already in destruction queue
	if not is_queued_for_deletion():
		queue_free()
