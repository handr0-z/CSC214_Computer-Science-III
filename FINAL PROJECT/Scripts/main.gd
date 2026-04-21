extends Node2D

# Constants
const TILE_ID_FOR_PLACEMENT: int = 22
const TILE_COORD_FOR_PLACEMENT: Vector2i = Vector2i(15, 0)

# Node References
@onready var timer: Timer = $Timer
@onready var path_2d: Path2D = %Path2D
@onready var tile_map: TileMap = %TileMap
@onready var game_form: Control = %game_form
@onready var upgrade_panel: Control = %game_form/upgrade_panel

# Exported Variables (Visible in Inspector)
@export var enemies: Array[PackedScene] = []
@export var max_health: float = 100
@export var level_number: int = 1

# Runtime Variables
var current_health: float = 100:
	set(value):
		current_health = value
		health_changed.emit()
		game_form.update_pb_health_display(current_health, max_health)
		if current_health <= 0:
			_game_over()

@export var coin: int = 100:
	set(value):
		coin = value
		game_form.update_coin_display(coin)

var preview_tower: Tower = null:
	set(value):
		if value != null and preview_tower != null:
			preview_tower.queue_free()
			tile_map.remove_child(preview_tower)
		preview_tower = value

var selected_tower: Tower = null

# Signals
signal health_changed

# Function called when the level scene initializes
func _ready() -> void:
	timer.timeout.connect(_spawn_enemy)

	game_form.w_tower_released.connect(func(w_tower):
		preview_tower = w_tower.P_TOWER.instantiate()
		tile_map.add_child(preview_tower)
	)

	current_health = max_health
	game_form.update_pb_health_display(current_health, max_health)
	game_form.update_coin_display(coin)

	for tower: Tower in get_tree().get_nodes_in_group("tower"):
		tower.initialize()
		_connect_tower_signals(tower)

	timer.start()

	game_form.replay_pressed.connect(_replay)
	game_form.next_pressed.connect(_go_to_next_level)

	upgrade_panel.upgrade_damage_pressed.connect(_on_upgrade_damage)
	upgrade_panel.upgrade_speed_pressed.connect(_on_upgrade_speed)
	upgrade_panel.upgrade_range_pressed.connect(_on_upgrade_range)

# Function called every frame for runtime updates
func _process(_delta: float) -> void:
	if preview_tower:
		_preview_tower()

# Function used to connect tower selection signals
func _connect_tower_signals(tower: Tower) -> void:
	if not tower.tower_selected.is_connected(_on_tower_selected):
		tower.tower_selected.connect(_on_tower_selected)

# Function triggered when a tower is selected
func _on_tower_selected(tower: Tower):
	if selected_tower and selected_tower != tower:
		selected_tower.deselect()

	selected_tower = tower
	selected_tower.select()
	upgrade_panel.show_for_tower(selected_tower)

# Function used to place a turret at the mouse position
func place_turret_at_mouse_position():
	var cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
	if can_place_turret_here(cell):
		coin -= preview_tower.cost
		preview_tower.initialize()
		_connect_tower_signals(preview_tower)
		preview_tower = null
		$audio_footstep.play()

# Function used to check if a turret can be placed on a tile
func can_place_turret_here(cell: Vector2i):
	var tile_id = tile_map.get_cell_source_id(1, cell)
	var tile_coord = tile_map.get_cell_atlas_coords(1, cell)
	return tile_id == TILE_ID_FOR_PLACEMENT and tile_coord == TILE_COORD_FOR_PLACEMENT

# Function used to spawn enemies on the path
func _spawn_enemy() -> void:
	var enemy_index: int = randi_range(0, enemies.size() - 1)
	var enemy = enemies[enemy_index].instantiate()
	path_2d.add_child(enemy)
	enemy.global_position = path_2d.curve.get_point_position(0)
	enemy.damaged.connect(_damaged)
	enemy.died.connect(func(loot_coin: int):
		coin += loot_coin
	)
	timer.wait_time = randf_range(1, 5)
	timer.start()

# Function triggered when the player takes damage
func _damaged(damage) -> void:
	current_health -= damage
	$audio_damage.play()

# Function called when the player loses all health
func _game_over() -> void:
	print("GameOver!")
	get_tree().paused = true
	game_form.game_over()

# Function used to upgrade a tower's damage stat
func _on_upgrade_damage(tower: Tower) -> void:
	if coin >= tower.damage_cost and tower.upgrade_damage():
		coin -= tower.damage_cost
		game_form.update_coin_display(coin)
		upgrade_panel.show_for_tower(tower)

# Function used to upgrade a tower's attack speed
func _on_upgrade_speed(tower: Tower) -> void:
	if coin >= tower.speed_cost and tower.upgrade_speed():
		coin -= tower.speed_cost
		game_form.update_coin_display(coin)
		upgrade_panel.show_for_tower(tower)

# Function used to upgrade a tower's range
func _on_upgrade_range(tower: Tower) -> void:
	if coin >= tower.range_cost and tower.upgrade_range():
		coin -= tower.range_cost
		game_form.update_coin_display(coin)
		upgrade_panel.show_for_tower(tower)

# Function used to update the preview tower position and color
func _preview_tower() -> void:
	if not preview_tower:
		return
	else:
		upgrade_panel.hide_panel()

	var cell = tile_map.local_to_map(tile_map.get_local_mouse_position())
	var turret_position = tile_map.map_to_local(cell)
	preview_tower.position = turret_position
	preview_tower.modulate = Color.RED if not can_place_turret_here(cell) else Color.WHITE

# Function used to remove the preview tower (unused?)
func _dispreview_tower() -> void:
	if not preview_tower:
		return
	preview_tower.queue_free()
	remove_child(preview_tower)

# Function used to restart the level
func _replay() -> void:
	current_health = max_health

	for actor in get_tree().get_nodes_in_group("actor"):
		if actor.is_in_group("cant free"):
			continue
		actor.queue_free()

	get_tree().paused = false
	coin = 100
	game_form.replay()
	game_form.update_pb_health_display(current_health, max_health)
	game_form.update_coin_display(coin)

# Function used to load the next level or return to menu
func _go_to_next_level() -> void:
	var next_level := level_number + 1

	if next_level > GlobalGameState.MAX_LEVEL:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
		return

	var next_scene := "res://Scenes/Level/Level%d.tscn" % next_level
	get_tree().paused = false
	get_tree().change_scene_to_file(next_scene)

func _on_win_timer_timeout() -> void:
	timer.stop()
	print("You Win!")
	var next_level := level_number + 1
	get_tree().paused = true
	game_form.show_victory()
	GlobalGameState.unlock_level(next_level)
# Function used to handle left-click placing of preview towers
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.is_released():

		if preview_tower:
			place_turret_at_mouse_position()
