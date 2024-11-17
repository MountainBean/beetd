class_name StrawHive
extends ItemHive

# Array indexed by parent class enum HIVE_ATTRIBUTES
static var STRAW_HIVE_ATTRIBUTES: Array = [
	150.0,		# DEFENCE_RADIUS
	8,			# CAP
]
static var STRAW_HIVE_TEXTURE: Texture = preload("res://assets/custom/hive_tile.png")


func _init(qty: int = 1):
	super._init("Straw Hive",
		"A simple but sturdy home for a Queen bee and her drones",
		STRAW_HIVE_ATTRIBUTES,
		qty
	)
	icon = STRAW_HIVE_TEXTURE
