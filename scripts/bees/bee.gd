class_name Bee

extends Node2D

const SCENE: PackedScene = preload("res://scenes/bees/bee.tscn")

enum states {CHILL, AGGRO}

var bee_state := states.CHILL
var health : int
var speed : float

var sting_delay := 1.5
var home := position
var target : Area2D

static func new_bee(bee_health: int, bee_speed: float) -> Bee:
	var new_bee: Bee = SCENE.instantiate()
	new_bee.health = bee_health
	new_bee.speed = bee_speed
	return new_bee

func _ready():
	pass

func _process(delta):
	if target != null and bee_state == states.AGGRO:
		# set home to the target position relative to the hive
		home = target.get_parent().position - get_parent().position

func _physics_process(delta):
	move(delta)

func die():
	get_parent().kill_bee(self)

func move(delta):
	# move towareds home
	position += position.direction_to(home) * speed * delta

func _on_area_2d_area_entered(area):
	if bee_state == states.AGGRO:
		area.get_parent().die()
		die()
