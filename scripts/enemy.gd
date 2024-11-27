class_name Enemy
extends CharacterBody2D

enum targeting_modes {PRODUCITVE}

@onready var animated_sprite = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("player")

const SPEEDX = 100
const SPEEDY = SPEEDX/2
var last_x = position.x
var progress = 0.0
var target := Vector2.ZERO
var targeting = targeting_modes.PRODUCITVE


func _ready():
	prioritise_target()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	last_x = position.x
	progress = Vector2(position.x - target.x, (position.y - target.y) * 2).abs()
	prioritise_target()
	move(delta)
	if position.x - last_x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	

func die():
	Signals.emit_signal("enemy_killed", self)
	queue_free()

func prioritise_target():
	var all_hives: Array = GameManager.tiles.values().filter(func(x): return x is Hive)
	if not all_hives.is_empty():
		all_hives.sort_custom(_sort_targets)
		target = all_hives[0].position
	else:
		target = player.position

func move(delta):
	velocity = position.direction_to(target) * Vector2(SPEEDX, SPEEDY)
	move_and_slide()


func _sort_targets(a: Hive, b: Hive):
	match targeting:
		targeting_modes.PRODUCITVE:
			if a.hive_queen == null and b.hive_queen == null:
				return true
			if a.hive_queen == null:
				return false
			if b.hive_queen == null:
				return true
			return _sort_by_productive(a, b)
				

func _sort_by_productive(a: Hive, b: Hive):
	if a.hive_queen.bee_productivity > b.hive_queen.bee_productivity:
		return true
	else:
		return false
