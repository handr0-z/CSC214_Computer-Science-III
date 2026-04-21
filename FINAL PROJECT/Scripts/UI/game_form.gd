extends Control
class_name GameForm

# Node References
@onready var h_box_container: HBoxContainer = %HBoxContainer
@onready var pb_health: ProgressBar = %pb_health
@onready var w_game_over: MarginContainer = $w_game_over
@onready var levelcomplete: MarginContainer = $levelcomplete
@onready var lab_coin: Label = %lab_coin

# Signals
signal w_tower_released
signal replay_pressed
signal next_pressed

# Function called when the UI node is loaded into the scene
func _ready() -> void:
	for w_tower in h_box_container.get_children():
		# Connect shop button click to emit tower release when affordable
		w_tower.released.connect(func() -> void:
			if w_tower.can_place_tower(owner.coin):
				w_tower_released.emit(w_tower)
		)

	# Connect game over replay button to forward the event
	w_game_over.btn_replay_pressed.connect(func() -> void:
		replay_pressed.emit()
	)

	replay()

# Function used to reset UI state and wire next-level button
func replay() -> void:
	w_game_over.hide()
	levelcomplete.hide()

	levelcomplete.next_pressed.connect(func() -> void:
		next_pressed.emit()
	)

# Function used to show the game over screen
func game_over() -> void:
	w_game_over.show()

# Function used to show the victory/level-complete screen
func show_victory() -> void:
	levelcomplete.show()

# Function used to update the health progress bar display
func update_pb_health_display(current_health: float, max_health: float) -> void:
	pb_health.value = current_health
	pb_health.max_value = max_health

# Function used to update the coin display and shop affordability indicators
func update_coin_display(coin: int) -> void:
	lab_coin.text = "Gold: " + str(coin)

	# Update each shop widget's cost display based on current gold
	for w_tower in h_box_container.get_children():
		w_tower.update_cost_display(coin)
