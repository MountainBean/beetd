extends TileMapLayer

@onready var flower_group_layer: TileMapLayer = get_parent().get_node("FlowerGroupLayer")
@onready var tile_map_layer_1: TileMapLayer = get_parent().get_node("TileMapLayer1")

enum GO {DOWNR, DOWN, DOWNL, UPL, UP, UPR}
# Called when the node enters the scene tree for the first time.
func _draw():
	if GameManager.DEBUG == true:
		for flower_cell in get_used_cells():
			draw_string(ThemeDB.fallback_font, map_to_local(flower_cell), str(flower_cell), HORIZONTAL_ALIGNMENT_CENTER, 30, 8)
	pass

func radial_search_flower(cell: Vector2i, radius: int):
	if cell in get_used_cells():
		return cell

	
	var current_cell:= Vector2i.ZERO
	var HEX_CORNERS = [
		Vector2i(-1, -1),	# UP
		Vector2i(0, -1),	# UP-RIGHT
		Vector2i(1, 0),		# DOWN-RIGHT
		Vector2i(1, 1),		# DOWN
		Vector2i(0, 1),		# DOWN-LEFT
		Vector2i(-1, 0),	# UP-LEFT
	]
	for r in range(1, radius + 1):
		for c in range(6):
			for a in range(r):
				current_cell = cell + r * HEX_CORNERS[c] + a * HEX_CORNERS[( c + 2 ) % 6]
				if current_cell in get_used_cells():
					return current_cell
				
	
	
	
	
