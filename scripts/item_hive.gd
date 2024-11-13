class_name ItemHive
extends Buildable

enum HIVE_ATTRIBUTES {
	DEFENCE_RADIUS,
	SPAWN_RATE,
	CAP,
	BEE_PRODUCTIVITY,
	BEE_TEMPERAMENT,
	BUILD_COST,
	BEE_HEALTH,
	BEE_SPEED
}

# Hive attributes
@export var defence_radius : float
@export var spawn_rate : float
@export var cap : int
@export var bee_productivity: float
@export var bee_temperament: Hive.temperament
@export var build_cost: float

# TODO: move these attributes to the bees or the queen item
@export var bee_health: int
@export var bee_speed: float

const HIVE_SCENE_PATH: String = "res://scenes/hives/hive.tscn"
static var HIVE_TEXTURE: Texture = preload("res://assets/custom/hive_tile.png")
