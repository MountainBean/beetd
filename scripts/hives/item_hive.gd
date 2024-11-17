class_name ItemHive
extends Buildable

# enum as a schema. this will index the attribute array given by sub-classes
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

# TODO: move these attributes to the bees or the queen item
@export var bee_productivity: float
@export var bee_temperament: Hive.temperament
@export var bee_health: int
@export var bee_speed: float

const HIVE_SCENE_PATH: String = "res://scenes/hives/hive.tscn"
static var HIVE_TEXTURE: Texture = preload("res://assets/custom/hive_tile.png")

func _init(item_name: String, item_desc: String, hive_attributes: Array, qty: int = 1):
	#! Constructor that takes an array of all attributes in order and 
	#  assigns them to the object
	
	super._init(item_name, item_desc, qty)
	
	icon = HIVE_TEXTURE
	stackable = true
	
	item_scene_path = HIVE_SCENE_PATH
	item_build_cost = HIVE_ATTRIBUTES.BUILD_COST
	
	defence_radius = hive_attributes[HIVE_ATTRIBUTES.DEFENCE_RADIUS]
	spawn_rate =  hive_attributes[HIVE_ATTRIBUTES.SPAWN_RATE]
	cap = hive_attributes[HIVE_ATTRIBUTES.CAP]
	
	bee_productivity = hive_attributes[HIVE_ATTRIBUTES.BEE_PRODUCTIVITY]
	bee_temperament = hive_attributes[HIVE_ATTRIBUTES.BEE_TEMPERAMENT]
	bee_health = hive_attributes[HIVE_ATTRIBUTES.BEE_HEALTH]
	bee_speed = hive_attributes[HIVE_ATTRIBUTES.BEE_SPEED]
	
