class_name Buildable
extends Item

var item_scene_path: String
var item_build_cost: float

func _init(item_name: String, item_desc: String, qty: int = 1):
	super._init(item_name, item_desc, qty)
	buildable = true

func get_buildable_scene() -> PackedScene:
	var scene = load(item_scene_path) as PackedScene
	return scene
