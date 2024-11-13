extends Node2D

@onready var hives = $Hives
@onready var tile_map_layer = $TileMapLayer
@onready var ghost_cursors = $GhostCursors
@onready var player = $Player

var grid_x: float
var grid_y: float

func _ready():
	grid_x = tile_map_layer.tile_set.tile_size.x
	grid_y = tile_map_layer.tile_set.tile_size.y
	print("grid_x: " + str(grid_x) + ", grid_y: " + str(grid_y))
	Signals.connect("place_mode", _on_place_mode)
	Signals.connect("view_mode", _on_view_mode)
	Signals.connect("build_at_global_pos", _on_build_at_global_pos)

func _process(delta):
	if GameManager.mode == GameManager.game_modes.PLACE and not player.ui.inventory_panel.visible:
		ghost_cursors.get_child(0).position = tile_map_layer.to_global(get_nearest_grid_centre(get_global_mouse_position()))

func _on_build_at_global_pos(global_position: Vector2):
	var new_building = Hive.build_from_item(GameManager.curr_item)
	var building_coords = get_tile_at(get_global_mouse_position())
	if new_building is Hive:
		if build_hive(new_building, building_coords):
			Signals.emit_signal("view_mode")
			GameManager.inventory.remove(GameManager.curr_item)

func build_hive(hive: Hive, map_coords: Vector2i) -> bool:
	if GameManager.curr_resource_count < hive.build_cost:
		print("You need more resource. \nRequired: " + str(hive.build_cost) + "\nActual: " + str(GameManager.curr_resource_count))
		return false
	if GameManager.tiles.has(str(map_coords)):
		print("There is already a hive here!")
		return false
	GameManager.tiles[str(map_coords)] = hive
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
