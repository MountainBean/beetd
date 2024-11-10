class_name Bee

extends Node2D

enum states {CHILL, AGGRO}

var bee_state := states.CHILL
var health := 100
var speed := 150.0
var sting_delay := 1.5
var home := position
var target : Area2D

func _ready():
	print("I'm a bee!")

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
	area.get_parent().die()
	die()
