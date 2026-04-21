extends PathFollow2D
class_name Enemy

# Exported Variables (Visible in Inspector)
@export var enemy_color: String = "Black"
@export var speed: float = 500
@export var max_hp: float = 10
@export var attack: float = 10
@export var loot_coin: int = 10

# Runtime Variables
var current_hp: float : set = _set_hp

# Node References
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var animated_sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")

# Signals
signal damaged
signal died

# Function called when enemy is loaded onto scene
func _ready() -> void:
	current_hp = max_hp
	progress_bar.max_value = max_hp
	progress_bar.hide()
	add_to_group("enemy")

	# Connect bullet collision
	$Area2D.area_entered.connect(_on_area_entered)

# Function called every frame
func _process(delta: float) -> void:
	# Move enemy along path
	progress += speed * delta
	_rotation_sprite()

	# Reached end of path → damage base
	if progress_ratio >= 0.99:
		damaged.emit(attack)
		_die()

# Function used to apply damage to enemy
func damage(amount: float) -> void:
	_set_hp(current_hp - amount)

# Function used to update enemy health
func _set_hp(value: float) -> void:
	current_hp = value
	progress_bar.value = value

	# Show bar if damaged
	if current_hp < max_hp:
		progress_bar.show()

	# Death check
	if current_hp <= 0:
		_die()

# Function used to handle enemy death
func _die() -> void:
	if has_node("audio_dead"):
		$audio_dead.play()

	died.emit(loot_coin)
	queue_free()

# Function used to rotate sprite based on path orientation
func _rotation_sprite() -> void:
	if animated_sprite == null:
		return

	var path = get_parent()
	if path is Path2D and path.curve:
		var baked: Transform2D = path.curve.sample_baked_with_rotation(progress)
		var angle: float = baked.get_rotation() + PI
		animated_sprite.rotation = angle

		var dir = angle_to_direction(angle)
		if animated_sprite.animation != dir:
			animated_sprite.play(dir)

# Function used to convert angle into animation direction
func angle_to_direction(angle: float) -> String:
	var a = fposmod(angle, TAU)

	if a < PI * 0.25 or a >= PI * 1.75:
		return "Right"
	elif a < PI * 0.75:
		return "Down"
	elif a < PI * 1.25:
		return "Left"
	else:
		return "Up"

# Function called when enemy collides with a bullet
func _on_area_entered(area: Area2D) -> void:
	# Bullet owns the Area2D
	if area.owner is Bullet:
		var bullet: Bullet = area.owner
		damage(bullet.damage)
		bullet.queue_free()
