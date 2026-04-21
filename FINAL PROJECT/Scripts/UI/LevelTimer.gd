extends Node

# Node References
@onready var remainingtime: Label = $RemainingTime
@onready var timer: Timer = $WinTimer

# Function used to compute minutes and seconds remaining in the level
func time_left_in_level() -> Array:
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var sec = int(time_left) % 60
	return [minute, sec]

# Function called every frame to update remaining time UI
func _process(_delta: float) -> void:
	remainingtime.text = "Time Left: " + "%02d:%02d" % time_left_in_level()
