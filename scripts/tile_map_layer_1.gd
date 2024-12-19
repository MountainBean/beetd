extends TileMapLayer

var altitude = FastNoiseLite.new()
var moisture = FastNoiseLite.new()
var fertility = FastNoiseLite.new()

const CHUNK_LOAD_DIST = 2 # Really lags as soon as you go near 10

const PLAYER_ALTITUDE = 0.3

const WIDTH = 32
const HEIGHT = 32

@onready var player = get_parent().get_node("Player")
@onready var flower_layer: TileMapLayer = get_parent().get_node("FlowerLayer")
@onready var tree_layer: TileMapLayer = get_parent().get_node("TreeLayer")

var loaded_chunks: Array[Vector2i] = []

func _draw():

	if GameManager.DEBUG == true:
		for chunk in loaded_chunks:
			draw_circle(map_to_local(Vector2i(chunk.x * WIDTH, chunk.y * HEIGHT)), 10.0, Color("Red"), true)
			draw_string(ThemeDB.fallback_font, map_to_local(Vector2i(chunk.x * WIDTH, chunk.y * HEIGHT)) + Vector2(8,8), str(chunk))
		var player_cell_position = local_to_map(player.position)
		var nearest_chunk = _get_nearest_chunk(player_cell_position)
		draw_circle(map_to_local(Vector2i(nearest_chunk.x * WIDTH, nearest_chunk.y * HEIGHT)), 15.0, Color("Blue"), false, 3.0)
		draw_string(ThemeDB.fallback_font, player.position + Vector2(8,8), str(player_cell_position))
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	altitude.seed = 123456789 #randi()
	moisture.seed = 987654321 #randi()
	fertility.seed = 10 #randi()
	
	altitude.frequency = 0.01
	moisture.frequency = 0.01
	fertility.frequency = 0.4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_cell_position = local_to_map(player.position)
	var nearest_chunk = _get_nearest_chunk(player_cell_position)
	
	load_approaching_chunks(nearest_chunk)
	unload_distant_chunks(nearest_chunk)
	if GameManager.DEBUG:
		queue_redraw()

func _get_nearest_chunk(player_cell_position: Vector2i):
	return Vector2i(snapped(player_cell_position.x, WIDTH) / WIDTH, snapped(player_cell_position.y, HEIGHT) / HEIGHT)

func generate_chunk(chunk: Vector2i):
	var chunk_origin = Vector2i(chunk.x * WIDTH, chunk.y * HEIGHT)
	for x in range(WIDTH):
		for y in range(HEIGHT):
			var moist = moisture.get_noise_2d(chunk_origin.x + x, chunk_origin.y + y)
			var alti = min(altitude.get_noise_2d(chunk_origin.x + x, chunk_origin.y + y) + PLAYER_ALTITUDE, 1)
			var fert = fertility.get_noise_2d(chunk_origin.x + x, chunk_origin.y + y)
			var tile_atlas_coords:= Vector2i.ZERO
			var cell:= Vector2i(chunk_origin.x + x, chunk_origin.y + y)
			
			if alti > 0:
				tile_atlas_coords = Vector2i(round(3 * (moist + 1) / 2), round(3 * alti))
				# Add trees
				if tile_atlas_coords == Vector2i(2,2):
					tree_layer.set_cell(cell, 0, Vector2i(0,5))
				
				# add flowers
				elif moist > 0.5:
					if fert > 0.1:
						flower_layer.set_cell(cell, 2, Vector2i.ZERO)
			else:
				tile_atlas_coords = Vector2i(5, round(3 * -alti))
			set_cell(cell, 3, tile_atlas_coords)
			
			
	if chunk not in loaded_chunks:
		loaded_chunks.append(chunk)

func load_approaching_chunks(nearest_chunk: Vector2i):
	
	for x in range(CHUNK_LOAD_DIST * 2 + 1):
		for y in range(CHUNK_LOAD_DIST * 2 + 1):
			if Vector2i(nearest_chunk.x + x - CHUNK_LOAD_DIST, nearest_chunk.y + y - CHUNK_LOAD_DIST) not in loaded_chunks:
				call_deferred("generate_chunk", Vector2i(nearest_chunk.x + x - CHUNK_LOAD_DIST, nearest_chunk.y + y - CHUNK_LOAD_DIST))
				#get_parent()._assign_fower_groups()

func unload_distant_chunks(nearest_chunk: Vector2i):
	var chunk_unload_dist = CHUNK_LOAD_DIST + 1
	
	for chunk in loaded_chunks:
		if absi(nearest_chunk.x - chunk.x) > chunk_unload_dist or absi(nearest_chunk.y - chunk.y) > chunk_unload_dist:
			clear_chunk(chunk)
			loaded_chunks.erase(chunk)
			

func clear_chunk(chunk):
	var chunk_origin = Vector2i(chunk.x * WIDTH, chunk.y * HEIGHT)
	for x in range(WIDTH):
		for y in range(HEIGHT):
			set_cell(Vector2i(chunk_origin.x + x, chunk_origin.y + y), -1, Vector2i(-1,-1))
			flower_layer.set_cell(Vector2i(chunk_origin.x + x, chunk_origin.y + y), -1, Vector2i(-1,-1))
			tree_layer.set_cell(Vector2i(chunk_origin.x + x, chunk_origin.y + y), -1, Vector2i(-1,-1))
