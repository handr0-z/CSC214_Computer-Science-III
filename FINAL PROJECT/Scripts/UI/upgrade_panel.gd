extends PanelContainer

# Signals
signal upgrade_damage_pressed(tower)
signal upgrade_speed_pressed(tower)
signal upgrade_range_pressed(tower)

# Node references
@onready var hb_damage: HBoxContainer = %hb_damage
@onready var hb_speed: HBoxContainer = %hb_speed
@onready var hb_range: HBoxContainer = %hb_range

@onready var lab_damage: Label = %lab_damage
@onready var lab_speed: Label = %lab_speed
@onready var lab_range: Label = %lab_range

@onready var btn_damage: Button = %btn_damage
@onready var btn_speed: Button = %btn_speed
@onready var btn_range: Button = %btn_range

# Current tower being upgraded
var current_tower: Tower = null

# Shows upgrade UI for the selected tower
func show_for_tower(tower: Tower) -> void:
	current_tower = tower
	visible = true
	update_stat_display()

# Hides the upgrade panel
func hide_panel() -> void:
	current_tower = null
	visible = false


# Updates all displayed stats and button labels
func update_stat_display() -> void:
	if current_tower == null:
		return

	# Damage
	var dmg_old := current_tower.get_damage()
	var dmg_new := current_tower.damage + (current_tower.damage_level + 1) * current_tower.damage_increase
	var dmg_lvl := current_tower.damage_level
	lab_damage.text = "Damage Lv. %s: %s → %s" % [dmg_lvl, dmg_old, dmg_new]

	# Speed (cooldown, lower is better)
	var spd_old := current_tower.get_cooldown()
	var new_speed_value := current_tower.attack_speed + (current_tower.speed_level + 1) * current_tower.speed_increase
	var spd_new := 1.0 / new_speed_value
	var spd_lvl := current_tower.speed_level
	lab_speed.text = "Speed Lv. %s: %.2f → %.2f" % [spd_lvl, spd_old, spd_new]

	# Range
	var rng_old := current_tower.get_range()
	var rng_new := current_tower.range + (current_tower.range_level + 1) * current_tower.range_increase
	var rng_lvl := current_tower.range_level
	lab_range.text = "Range Lv. %s: %s → %s" % [rng_lvl, rng_old, rng_new]

	# Button costs
	btn_damage.text = str(current_tower.damage_cost)
	btn_speed.text = str(current_tower.speed_cost)
	btn_range.text = str(current_tower.range_cost)

# Called when the damage upgrade button is pressed
func _on_btn_damage_pressed() -> void:
	if current_tower and current_tower.upgrade_damage():
		emit_signal("upgrade_damage_pressed", current_tower)
		update_stat_display()

# Called when the speed upgrade button is pressed
func _on_btn_speed_pressed() -> void:
	if current_tower and current_tower.upgrade_speed():
		emit_signal("upgrade_speed_pressed", current_tower)
		update_stat_display()

# Called when the range upgrade button is pressed
func _on_btn_range_pressed() -> void:
	if current_tower and current_tower.upgrade_range():
		emit_signal("upgrade_range_pressed", current_tower)
		update_stat_display()
