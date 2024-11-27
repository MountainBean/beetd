class_name Bee

extends Node2D

const SCENE: PackedScene = preload("res://scenes/bees/bee.tscn")

var health : int
var speed : float

var re_target_delay_range = Vector2(0.1, 0.5)

var sting_delay := 1.5
var home := position
var target : Node2D
var stung := false

@onready var hive: Hive = get_parent().get_parent()
@onready var state_machine = $StateMachine
@onready var area_2d = $Area2D

static func new_bee(bee_health: int, bee_speed: float) -> Bee:
	var new_bee: Bee = SCENE.instantiate()
	new_bee.health = bee_health
	new_bee.speed = bee_speed
	return new_bee

func die():
	hive.kill_bee(self)

func move(delta):
	# move towareds home
	position += position.direction_to(home) * speed * delta

func set_target_with_delay(new_target):
	await get_tree().create_timer(
		randf_range(re_target_delay_range.x, re_target_delay_range.y), false
	).timeout
	if new_target == null:
		return
	target = new_target

func _on_area_2d_body_entered(body):
	if stung:
		return
	state_machine.current_state.enemy_touched(body)
