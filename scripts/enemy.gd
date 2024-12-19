class_name Enemy
extends CharacterBody2D

enum targeting_modes {PRODUCITVE}

@onready var animated_sprite = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("player")

const SPEEDX = 100
const SPEEDY = SPEEDX/2
var last_x = position.x
var progress = 0.0
var target : Node2D
var targeting = targeting_modes.PRODUCITVE


func _ready():
	prioritise_target()

func _draw():
	draw_line(Vector2.ZERO, to_local(target.global_position), Color("#ffffff50"), 4)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	last_x = position.x
	progress = Vector2.ZERO.distance_to(to_local(target.global_position))
	move(delta)
	if position.x - last_x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	queue_redraw()
	

func die():
	Signals.emit_signal("enemy_killed", self)
	queue_free()

func prioritise_target():
	var all_cells_with_hives: Array = GameManager.tiles.values().filter(func(x): return x.has("hive"))
	
	if not all_cells_with_hives.is_empty():
		all_cells_with_hives.sort_custom(_sort_targets)
		target = all_cells_with_hives[0]["hive"]
	else:
		target = player

func move(delta):
	velocity = Vector2.ZERO.direction_to(to_local(target.global_position)) * Vector2(SPEEDX, SPEEDY).abs()
	move_and_slide()


func _sort_targets(a: Dictionary, b: Dictionary):
	match targeting:
		targeting_modes.PRODUCITVE:
			if a["hive"].hive_queen == null and b["hive"].hive_queen == null:
				return true
			if a["hive"].hive_queen == null:
				return false
			if b["hive"].hive_queen == null:
				return true
			return _sort_by_productive(a["hive"], b["hive"])
				

func _sort_by_productive(a: Hive, b: Hive):
	if a.hive_queen.bee_productivity > b.hive_queen.bee_productivity:
		return true
	else:
		return false
