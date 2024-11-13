class_name Buildable
extends Item

@export var item_scene_path: String

func _init():
	buildable = true

func get_buildable_scene() -> PackedScene:
	var scene = load(item_scene_path) as PackedScene
	return scene
