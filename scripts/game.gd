extends Node2D

@onready var hives = $Hives
@onready var tile_map_layer = $TileMapLayer
@onready var ghost_cursors = $GhostCursors

var grid_x: float
var grid_y: float

func _ready():
	grid_x = tile_map_layer.tile_set.tile_size.x
	grid_y = tile_map_layer.tile_set.tile_size.y
	print("grid_x: " + str(grid_x) + ", grid_y: " + str(grid_y))
	Signals.connect("mode_just_changed", _on_mode_change)

func _process(delta):
	if GameManager.mode == GameManager.game_modes.PLACE:
		ghost_cursors.get_child(0).position = tile_map_layer.to_global(get_nearest_grid_centre(get_global_mouse_position()))
		if Input.is_action_just_pressed("LMB"):
			var new_building = GameManager.curr_buildable.instantiate()
			var building_coords = get_tile_at(get_global_mouse_position())
			if new_building is Hive:
				build_hive(new_building, building_coords)

func build_hive(hive: Hive, map_coords: Vector2i):
	if not GameManager.tiles.has(str(map_coords)):
		GameManager.tiles[str(map_coords)] = hive
		hive.position = tile_map_layer.map_to_local(map_coords)
		hives.add_child(hive)
		print("new hive at: " + str(map_coords))
	else:
		print("There is already a hive here!")

func get_tile_at(global_coords: Vector2) -> Vector2i:
	return tile_map_layer.local_to_map(tile_map_layer.to_local(global_coords))

func get_nearest_grid_centre(global_coords: Vector2) -> Vector2:
	var map_coords: Vector2i = get_tile_at(global_coords)
	return tile_map_layer.map_to_local(map_coords)
	

func instantiate_ghost_object(item: Resource) -> Node2D:
	var tempBuildObject = item.instantiate()
	tempBuildObject.modulate = Color(1,1,1,0.5)
	return tempBuildObject
	

func _on_mode_change(new_mode: GameManager.game_modes):
	match new_mode:
		GameManager.game_modes.PLACE:
			_on_change_to_place_mode(GameManager.curr_buildable)
		GameManager.game_modes.VIEW:
			_on_change_to_view_mode()

func _on_change_to_place_mode(buildable: Resource):
	var ghost_object = instantiate_ghost_object(buildable)
	if ghost_object is Hive:
		ghost_object.cap = 0
	ghost_cursors.add_child(ghost_object)

func _on_change_to_view_mode():
	ghost_cursors.get_child(0).queue_free()
