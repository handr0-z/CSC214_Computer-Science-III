extends Node

# Exported Variables (Visible in Inspector)
const MAX_LEVEL: int = 2
const SAVE_PATH: String = "user://save.cfg"
var player_name: String = "Player"
# Runtime Variables
var unlocked_levels: Array[int] = [1]   # Level 1 unlocked by default

# Function called when level progress system loads
func _ready() -> void:
	_load_progress()

# Function used to check whether a level is unlocked
func is_level_unlocked(level: int) -> bool:
	return level in unlocked_levels

# Function used to unlock a level and save progress
func unlock_level(level: int) -> void:
	if level > MAX_LEVEL:
		var manager := Leaderboard.new()
		manager.add_score(player_name,100)  # placeholder value to mark a "winner"
		get_tree().change_scene_to_file("res://scenes/ui/Leaderboard.tscn")
		return
	
	# Ignore if already unlocked
	if level in unlocked_levels:
		return

	# Unlock this level (and all previous levels)
	for i in range(1, level + 1):
		if i not in unlocked_levels:
			unlocked_levels.append(i)

	unlocked_levels.sort()
	_save_progress()

# Function used to load saved progress from file
func _load_progress() -> void:
	var config := ConfigFile.new()
	var err := config.load(SAVE_PATH)

	if err == OK:
		var loaded = config.get_value("Progress", "unlocked_levels", [1])
		player_name = config.get_value("player", "name", "Player")
		unlocked_levels.clear()

		# Ensure loaded data is valid
		if loaded is Array:
			for v in loaded:
				unlocked_levels.append(int(v))
		else:
			unlocked_levels.append(1)
	else:
		unlocked_levels = [1]
		player_name = "Player"

# Function used to save current progress to file
func _save_progress() -> void:
	var config := ConfigFile.new()
	config.set_value("Progress", "unlocked_levels", unlocked_levels)
	config.set_value("player", "name", player_name)
	config.save(SAVE_PATH)
	
func new_game() -> void:
	# Reset all progress to defaults
	unlocked_levels = [1]
	player_name = "Player"

	# Save the fresh data to save.cfg
	var config := ConfigFile.new()
	config.set_value("progress", "unlocked_levels", unlocked_levels)
	config.set_value("player", "name", player_name)
	config.save(SAVE_PATH)

	print("New game started. Progress reset.")
	
	
