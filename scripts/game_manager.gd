extends Node

enum game_modes {VIEW, PLACE}

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

func _ready():
	Signals.connect("place_mode", _on_place_mode)
	Signals.connect("view_mode", _on_view_mode)
	curr_resource_count = 200
	
	inventory = Inventory.new()
	
	# create example hive item
	inventory.add(generate_hive(Hive.temperament.PASSIVE))
	inventory.add(generate_hive(Hive.temperament.AGGRESSIVE))
	for item in inventory.items:
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
	var hive: Item = ItemHive.new()
	
	hive.name = "Regular Hive"
	hive.description = "This is a hive."
	hive.stackable = true
	hive.icon = ItemHive.HIVE_TEXTURE
	hive.stackable = true
	hive.quantity = 1
	
	hive.item_scene_path = ItemHive.HIVE_SCENE_PATH
	
	match temperament:
		Hive.temperament.AGGRESSIVE:
			hive.defence_radius = DefensiveHive.DEFENSIVE_HIVE_ATTRIBUTES[ItemHive.HIVE_ATTRIBUTES.DEFENCE_RADIUS]
			hive.spawn_rate =  DefensiveHive.DEFENSIVE_HIVE_ATTRIBUTES[ItemHive.HIVE_ATTRIBUTES.SPAWN_RATE]
			hive.cap = DefensiveHive.DEFENSIVE_HIVE_ATTRIBUTES[ItemHive.HIVE_ATTRIBUTES.CAP]
			hive.bee_productivity = DefensiveHive.DEFENSIVE_HIVE_ATTRIBUTES[ItemHive.HIVE_ATTRIBUTES.BEE_PRODUCTIVITY]
			hive.bee_temperament = DefensiveHive.DEFENSIVE_HIVE_ATTRIBUTES[ItemHive.HIVE_ATTRIBUTES.BEE_TEMPERAMENT]
			hive.build_cost = DefensiveHive.DEFENSIVE_HIVE_ATTRIBUTES[ItemHive.HIVE_ATTRIBUTES.BUILD_COST]
			hive.bee_health = DefensiveHive.DEFENSIVE_HIVE_ATTRIBUTES[ItemHive.HIVE_ATTRIBUTES.BEE_HEALTH]
			hive.bee_speed = DefensiveHive.DEFENSIVE_HIVE_ATTRIBUTES[ItemHive.HIVE_ATTRIBUTES.BEE_SPEED]
			hive.modifier_icon = DefensiveHive.DEFENSIVE_MODIFIER_ICON
		Hive.temperament.PASSIVE:
			hive.defence_radius = GatheringHive.GATHERING_HIVE_ATTRIBUTES[ItemHive.HIVE_ATTRIBUTES.DEFENCE_RADIUS]
			hive.spawn_rate =  GatheringHive.GATHERING_HIVE_ATTRIBUTES[ItemHive.HIVE_ATTRIBUTES.SPAWN_RATE]
			hive.cap = GatheringHive.GATHERING_HIVE_ATTRIBUTES[ItemHive.HIVE_ATTRIBUTES.CAP]
			hive.bee_productivity = GatheringHive.GATHERING_HIVE_ATTRIBUTES[ItemHive.HIVE_ATTRIBUTES.BEE_PRODUCTIVITY]
			hive.bee_temperament = GatheringHive.GATHERING_HIVE_ATTRIBUTES[ItemHive.HIVE_ATTRIBUTES.BEE_TEMPERAMENT]
			hive.build_cost = GatheringHive.GATHERING_HIVE_ATTRIBUTES[ItemHive.HIVE_ATTRIBUTES.BUILD_COST]
			hive.bee_health = GatheringHive.GATHERING_HIVE_ATTRIBUTES[ItemHive.HIVE_ATTRIBUTES.BEE_HEALTH]
			hive.bee_speed = GatheringHive.GATHERING_HIVE_ATTRIBUTES[ItemHive.HIVE_ATTRIBUTES.BEE_SPEED]
			hive.modifier_icon = GatheringHive.GATHERING_MODIFIER_ICON
	
	return hive
