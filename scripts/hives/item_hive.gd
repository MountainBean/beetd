class_name ItemHive
extends Buildable

# enum as a schema. this will index the attribute array given by sub-classes
enum HIVE_ATTRIBUTES {
	DEFENCE_RADIUS,
	CAP,
	BUILD_COST,
}

# Hive attributes
@export var defence_radius : float
@export var cap : int


const HIVE_SCENE_PATH: String = "res://scenes/hives/hive.tscn"

func _init(item_name: String, item_desc: String, hive_attributes: Array, qty: int = 1):
	#! Constructor that takes an array of all attributes in order and 
	#  assigns them to the object
	
	super._init(item_name, item_desc, qty)
	
	stackable = true
	
	item_scene_path = HIVE_SCENE_PATH
	item_build_cost = hive_attributes[HIVE_ATTRIBUTES.BUILD_COST]
	
	defence_radius = hive_attributes[HIVE_ATTRIBUTES.DEFENCE_RADIUS]
	cap = hive_attributes[HIVE_ATTRIBUTES.CAP]
	
