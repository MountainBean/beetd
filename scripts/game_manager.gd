extends Node

enum game_modes {VIEW, PLACE}

const DEBUG = true		# Shows debug draw calls

var player_inventory_open: bool = false
var tiles: Dictionary = {}
var inventory: Inventory
var enemies: Dictionary = {}
var use_world_gen = true

var mode = game_modes.VIEW:
	set(new_mode):
		if mode != new_mode:
			mode = new_mode
			Signals.emit_signal("mode_just_changed", new_mode)
			match mode:
				game_modes.VIEW:
					print("Switched to VIEW mode")
				game_modes.PLACE:
					print("Switched to PLACE mode")

var curr_item: Item
var highlighted_hive: Hive = null:
	set(new_hive):
		if highlighted_hive != null:
			highlighted_hive.sprite.material = null
			highlighted_hive.sprite.modulate = Color(1,1,1,1)
		highlighted_hive = new_hive
		if highlighted_hive != null:
			highlighted_hive.sprite.material = preload("res://scripts/shaders/outline_white_1px.tres")
			highlighted_hive.sprite.material.set_shader_parameter("Outline Colour", "#76ffff")
			highlighted_hive.sprite.modulate = "#76ffff"
var curr_resource_count: float:
	set(value):
		Signals.emit_signal("resource_count_updated", value)
		curr_resource_count = value

var player_pos: Vector2 = Vector2.ZERO
var wave_time := 5000
var wave_timer: SceneTreeTimer
var wave_no: int = 0
var enemy_total: int = 0

func _ready():
	Signals.connect("place_mode", _on_place_mode)
	Signals.connect("view_mode", _on_view_mode)
	Signals.connect("enemy_spawned", _on_enemy_spawned)
	Signals.connect("enemy_killed", _on_enemy_killed)
	curr_resource_count = 200
	
	inventory = Inventory.new()
	
	# create example hive item
	inventory.add(StrawHive.new(), 0, 99)
	inventory.add(FieldQueen.new(), 2, 99)
	inventory.add(GuardQueen.new(), 4, 99)
	for item in inventory.items:
		if item:
			item.inventory = inventory
	
	start_wave_timer()

func _on_place_mode():
	mode = game_modes.PLACE

func _on_view_mode():
	mode = game_modes.VIEW

func add_to_resource_count(resource_gain: float):
	curr_resource_count += resource_gain

func remove_from_resource_count(resource_loss: float):
	curr_resource_count -= resource_loss

func get_player_inventory() -> Inventory:
	return inventory

func begin_wave():
	Signals.emit_signal("begin_wave")

func start_wave_timer():
	wave_timer = get_tree().create_timer(wave_time, false)
	wave_timer.connect("timeout", begin_wave)

func _on_enemy_spawned(enemy: Enemy):
	#print("Enemy spawned: " + str(enemy))
	enemies[str(enemy)] = true
	enemy_total += 1

func _on_enemy_killed(enemy: Enemy):
	if enemies.erase(str(enemy)):
		if enemy_total == 1:
			Signals.emit_signal("last_enemy_killed")
			Signals.emit_signal("wave_end")
		#print("Enemy killed: " + str(enemy))
		enemy_total -= 1
