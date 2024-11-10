extends Node2D
var enemy_spawn_rate = 0.2

@onready var path_2d = $Path2D
@onready var enemy_spawn_timer = $Path2D/EnemySpawnTimer
@onready var enemy = preload("res://scenes/enemy.tscn")

func _ready():
	enemy_spawn_timer.wait_time = enemy_spawn_rate

func _on_enemy_spawn_timer_timeout():
	var new_enemy = enemy.instantiate()
	path_2d.add_child(new_enemy)
