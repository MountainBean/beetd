extends Node2D

@onready var hives = $Hives
@onready var tile_map_layer = $TileMapLayer
@onready var flower_group_layer = $FlowerGroupLayer
@onready var ghost_cursors = $GhostCursors
@onready var player = $Player
@onready var enemy_spawner = $EnemySpawner

var highlights: Array = []

func _ready():
	Signals.connect("place_mode", _on_place_mode)
	Signals.connect("view_mode", _on_view_mode)
	Signals.connect("build_at_global_pos", _on_build_at_global_pos)
	Signals.connect("place_queen_in_hive", _on_place_queen_in_hive)
	Signals.connect("begin_wave", _on_begin_wave)
	Signals.connect("enemy_killed", _on_enemy_killed)
	
	# allocate flora regions
	for tile_coords in tile_map_layer.get_used_cells():
		var tile_data = tile_map_layer.get_cell_tile_data(tile_coords)
		var coord_data = GameManager.tiles.get(str(tile_coords))
		if coord_data:
			if coord_data["flower_group"] > 0:
				continue
		else:
			coord_data = {}
		var tile_data_flora = tile_data.get_custom_data("flora")
		match tile_data_flora:
			Flowers.variety.NONE as int:
				continue
			Flowers.variety.GRASS as int:
				continue
			Flowers.variety.LAWN_DAISY as int:
				coord_data["flower_group"] = tile_data_flora
				var neighbors = tile_map_layer.get_surrounding_cells(tile_coords)
				for neighbor in neighbors:
					var neighbor_coord_data = GameManager.tiles.get(str(tile_coords)) if GameManager.tiles.get(str(tile_coords)) else {}
					if tile_map_layer.get_cell_tile_data(neighbor).get_custom_data("flora") != Flowers.variety.GRASS as int:
						continue
					neighbor_coord_data.get_or_add("flower_group", tile_data_flora)
					GameManager.tiles.get_or_add(str(neighbor), neighbor_coord_data)
				GameManager.tiles.get_or_add(str(tile_coords), coord_data)

	

func _process(delta):
	if GameManager.mode == GameManager.game_modes.PLACE:
		if GameManager.curr_item is Buildable:
			# draw a non-functional ghost hive under the cursor
			if ghost_cursors.get_children().size() > 0:
				ghost_cursors.get_child(0).position = tile_map_layer.to_global(get_nearest_grid_centre(get_global_mouse_position()))
		elif GameManager.curr_item is Queen:
			var all_hives: Array = GameManager.tiles.values().filter(func(x): return x is Hive)
			for hive in all_hives:
				if hive.sprite.material == null and hive.hive_queen == null:
					hive.sprite.material = preload("res://scripts/shaders/outline_white_1px.tres")
					if not highlights.has(hive):
						highlights.append(hive)
			# Get GameManager to highlight the hive under the cursor
			var cell_data_at_mouse = GameManager.tiles.get(
				str(get_tile_at(			# TODO: ugly af
					get_global_mouse_position() + Vector2(0,tile_map_layer.tile_set.tile_size.y/2)
				))				# y offset because the hives are tall
			)
			if cell_data_at_mouse:
				var hive_at_mouse: Hive = cell_data_at_mouse.get("hive")
				if hive_at_mouse and hive_at_mouse.hive_queen == null:
					GameManager.highlighted_hive = hive_at_mouse
				else:
					GameManager.highlighted_hive = null
	else:
		for item in highlights:
			if item.sprite.material != null:
				item.sprite.material = null
				highlights.erase(item)
		
		flower_group_layer.clear()
		var current_coords_hovered = tile_map_layer.local_to_map(tile_map_layer.get_local_mouse_position())
		highlight_flower_group(current_coords_hovered)
		
		if Input.is_action_just_pressed("LMB"):
			print("tile at: " + str(tile_map_layer.local_to_map(tile_map_layer.get_local_mouse_position())))
			print("flora: " + str(get_clicked_tile_data("flora")))
			print("flower_group: " + str(get_clicked_coord_data_key_value("flower_group")))

func _on_build_at_global_pos(global_position: Vector2):
	var new_building = Hive.build_from_item(GameManager.curr_item)
	var building_coords = get_tile_at(get_global_mouse_position())
	if new_building is Hive:
		if build_hive(new_building, building_coords):
			GameManager.inventory.remove(GameManager.curr_item, GameManager.curr_item.inventory_index)

func build_hive(hive: Hive, map_coords: Vector2i) -> bool:
	if GameManager.curr_resource_count < hive.build_cost:
		print("You need more resource. \nRequired: " + str(hive.build_cost) + "\nActual: " + str(GameManager.curr_resource_count))
		return false
	var cell_data = GameManager.tiles.get(str(map_coords))
	if cell_data and cell_data.has("hive"):
		print("There is already a hive here!")
		return false
	GameManager.tiles[str(map_coords)]["hive"] = hive
	hive.position = tile_map_layer.map_to_local(map_coords)
	hives.add_child(hive)
	GameManager.remove_from_resource_count(hive.build_cost)
	print("new hive at: " + str(map_coords))
	return true

func get_tile_at(global_coords: Vector2) -> Vector2i:
	return tile_map_layer.local_to_map(tile_map_layer.to_local(global_coords))

func get_nearest_grid_centre(global_coords: Vector2) -> Vector2:
	var map_coords: Vector2i = get_tile_at(global_coords)
	return tile_map_layer.map_to_local(map_coords)
	

func instantiate_ghost_object(buildable_item: Buildable) -> Node2D:
	# TODO: when we have more buildable structures other than hives, 
	# 		we'll need to use the parent class here, not Hive
	var tempBuildObject = Hive.build_from_item(buildable_item)
	tempBuildObject.modulate = Color(1,1,1,0.5)
	return tempBuildObject

func _on_place_mode():
	for ghost in ghost_cursors.get_children():
		ghost.queue_free()
	if GameManager.curr_item is Buildable:
		var ghost_object = instantiate_ghost_object(GameManager.curr_item)
		if ghost_object is Hive:
			ghost_object.cap = 0
		ghost_cursors.add_child(ghost_object)
	


func _on_view_mode():
	for ghost in ghost_cursors.get_children():
		ghost.queue_free()


func _on_resource_tick_timeout():
	if hives.get_child_count() == 0:
		pass
	var resource_gain := 0.0
	for hive in hives.get_children():
		resource_gain += hive.get_resource_count()
	GameManager.add_to_resource_count(resource_gain)

func _on_place_queen_in_hive(queen: Queen, hive: Hive):
	if hive.hive_queen != null:
		print("This hive already has a queen!")
		return
	hive.hive_queen = queen
	hive.modifier_icon.texture = queen.hive_modifier_icon
	hive.modifier_icon.visible = true
	if queen.quantity == 1:
		GameManager.highlighted_hive = null
	GameManager.inventory.remove(queen, queen.inventory_index)

func _on_begin_wave():
	var wave_info = SpawnInfo.new()
	GameManager.wave_no += 1
	wave_info.enemy = preload("res://scenes/enemy.tscn")
	wave_info.enemy_num = 1 * GameManager.wave_no
	wave_info.enemy_spawn_delay = enemy_spawner.time / 30
	wave_info.time_start = 0
	wave_info.time_end = 30
	enemy_spawner.spawns.append(wave_info)
	enemy_spawner.time = 0.0
	await Signals.last_enemy_killed
	enemy_spawner.spawns.pop_back()
	GameManager.start_wave_timer()

func _on_enemy_killed(enemy: Enemy):
	if enemy_spawner.get_children().filter(func(x): return x is Enemy).size() <= 1:
		if enemy_spawner.time >= enemy_spawner.spawns[0].time_end: 
			Signals.emit_signal("last_enemy_killed")


func get_clicked_tile_data(data_layer: String):
	var clicked_cell = tile_map_layer.local_to_map(tile_map_layer.get_local_mouse_position())
	var data = tile_map_layer.get_cell_tile_data(clicked_cell)
	if data:
		return data.get_custom_data(data_layer)
	else:
		return 0

func get_clicked_coord_data_key_value(key: String):
	var clicked_cell = tile_map_layer.local_to_map(tile_map_layer.get_local_mouse_position())
	var data = GameManager.tiles.get(str(clicked_cell))
	if data:
		return data.get(key)
	else:
		return 0

func highlight_flower_group(cell: Vector2i):
	var data = GameManager.tiles.get(str(cell))
	var vpr = get_viewport_rect().size * 1.1
	var top_left = tile_map_layer.local_to_map(tile_map_layer.to_local(Vector2(player.global_position.x - vpr.x / 2, player.global_position.y - vpr.y / 2)))
	var bottom_right = tile_map_layer.local_to_map(tile_map_layer.to_local(Vector2(player.global_position.x + vpr.x / 2, player.global_position.y + vpr.y / 2)))
	if !_is_cell_in_tile_box(cell, top_left, bottom_right):
		return
	if data and data.get("flower_group"):
		if data.get("flower_group") > 1:
			flower_group_layer.set_cell(cell, 4, Vector2i(0,0))
			for neighbor in tile_map_layer.get_surrounding_cells(cell):
				if flower_group_layer.get_cell_source_id(neighbor) != 4:
					highlight_flower_group(neighbor)

func _is_cell_in_tile_box(cell: Vector2i, min: Vector2i, max: Vector2i):
	if cell.x > min.x and cell.x < max.x and cell.y > min.y and cell.y < max.y:
		return true
	else: 
		return false
