class_name Leaderboard
extends Control

var high_scores: Array = []
var save_path := "user://highscores.json"

func load_high_scores():
	# Check if file exists
	if not FileAccess.file_exists(save_path):
		high_scores = []
		return

	var file := FileAccess.open(save_path, FileAccess.READ)
	var content := file.get_as_text()

	var result: Variant = JSON.parse_string(content)

	if result is Array:
		high_scores = result
	else:
		high_scores = []


func save_high_scores():
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(high_scores))


func add_score(player_name: String, score: int):
	load_high_scores()

	var entry: Dictionary = {

		"name": player_name,
		"score": score
	}
	print(player_name)
	high_scores.append(entry)

	high_scores.sort_custom(_sort_by_score)

	high_scores = high_scores.slice(0, 7)

	save_high_scores()


func _sort_by_score(a, b):
	return b["score"] - a["score"]

func display_scores():
	load_high_scores()
	for child in get_children():
		print(child.name)
	
	var base := $MarginContainer2/VBoxContainer/MarginContainer/VBoxContainer

	for i in range(7):
		print(i)
		var stat: Control = base.get_node("Stat" + str(i+1))
		var name_label = stat.get_node("NameLabel")
		var score_label = stat.get_node("RankLabel")

		if i < high_scores.size():
			name_label.text = str(high_scores[i]["name"])
			score_label.text = str(high_scores[i]["score"])
		else:
			name_label.text = "-"
			score_label.text = "-"
func _ready():
	await get_tree().process_frame
	display_scores()
