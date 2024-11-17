extends Node

enum game_modes {VIEW, PLACE}

var player_inventory_open: bool = false
var tiles: Dictionary = {}
var inventory: Inventory

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
var curr_resource_count: float:
	set(value):
		Signals.emit_signal("resource_count_updated", value)
		curr_resource_count = value

var player_pos: Vector2 = Vector2.ZERO

func _ready():
	Signals.connect("place_mode", _on_place_mode)
	Signals.connect("view_mode", _on_view_mode)
	Signals.connect("hovered", _on_hive_hovered)
	Signals.connect("un_hovered", _on_hive_un_hovered)
	curr_resource_count = 200
	
	inventory = Inventory.new()
	
	# create example hive item
	inventory.add(generate_hive(Hive.temperament.PASSIVE), 0, 2)
	inventory.add(generate_hive(Hive.temperament.AGGRESSIVE), 1, 3)
	inventory.add(FieldQueen.new(), 2, 2)
	for item in inventory.items:
		if item:
			item.inventory = inventory

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


func generate_hive(temperament: Hive.temperament) -> ItemHive:
	match temperament:
		Hive.temperament.AGGRESSIVE:
			var hive = DefensiveHive.new()
			return hive
		Hive.temperament.PASSIVE:
			var hive = GatheringHive.new()
			return hive
		_:
			return

func _on_hive_hovered(hive: Hive):
	if mode == game_modes.PLACE and curr_item is Queen:
		hive.sprite.material = preload("res://scripts/shaders/outline_white_1px.tres")

func _on_hive_un_hovered(hive: Hive):
	hive.sprite.material = null
