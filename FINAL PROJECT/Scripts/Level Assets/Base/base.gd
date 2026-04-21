extends Node2D

# Exported Variables (Visible in Inspector)
@export var max_health: int = 100

# Runtime Variables
var current_health: int

# Signals
signal base_destroyed                                # Emitted when HP hits 0
signal health_changed(current_health, max_health)    # Emitted whenever HP updates

# Function called when base is loaded onto scene
func _ready():
	# Set Starting Health
	current_health = max_health
	
	# Make sure UI shows correct health immediately
	emit_signal("health_changed", current_health, max_health)
	
	# Allow enemies to find this base
	add_to_group("base")

# Function used to calculate damage taken
func take_damage(amount: int):
	# Calcualte HP but never allow a negative value
	current_health = max(current_health - amount, 0)
	
	# Update any UI elements listening for health changes
	emit_signal("health_changed", current_health, max_health)
	
	# If HP hits 0, broadcast destruction event
	if current_health <= 0:
		print("BASE DESTROYED")
		emit_signal("base_destroyed")

 # Function used to reset the health of the base when restarting game.
func reset_health():
	current_health = max_health
	emit_signal("health_changed", current_health, max_health)
	print("[DEBUG] Base health reset. Current HP:", current_health)

# Function to detect enemy
func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		# Apply damage from the enemy's attack stat
		take_damage(body.attack)
		
		# Enemy is destroyed after damaging the base
		body.queue_free()
