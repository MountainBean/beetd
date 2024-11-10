extends Area2D

class_name Hive

enum states {CHILL, AGGRO}
enum targeting_mode {CLOSEST}

const ORBIT_DISTANCE := 32.0
const BEE_UNIT := 12

var bees: Array[Bee] = []
var enemies: Array[Area2D] = []

var hive_config := targeting_mode.CLOSEST
var hive_state := states.CHILL:
	set(value):
		match value:
			states.AGGRO:
				arrow_pointer.visible = true
			states.CHILL:
				arrow_pointer.visible = false
		for bee in bees:
			bee.bee_state = value as Bee.states
		hive_state = value

var population: int
var defence_radius := 200.0

@export var spawn_rate := 1.0
@export var cap := 8

@onready var timer := $Timer
@onready var hive_defend_radius := $HiveDefendRadius
@onready var arrow_pointer = $ArrowPointer


func _ready():
	timer.wait_time = 1 / spawn_rate
	arrow_pointer.visible = false

func _process(delta):
	if bees.size() < cap and timer.is_stopped():
		timer.start()
	if not enemies.is_empty():
		arrow_pointer.global_position = enemies.back().global_position

func spawn_bee():
	# append a new bee to the hive's bee array, increase population and home all bees
	var new_bee: Bee = preload("res://scenes/bee.tscn").instantiate()
	new_bee.target = enemies.back() if not enemies.is_empty() else null
	new_bee.bee_state = hive_state as Bee.states
	bees.append(new_bee)
	add_child(bees.back())
	population += 1
	attack_enemies()
	home_all_bees()

func home_all_bees():
	if hive_state == states.CHILL:
		for i in range(population):
			var home_offset = ( 0.5 * ( 1 - population ) + i ) * BEE_UNIT
			bees[i].home = Vector2.from_angle( ( -PI / 2 ) + (home_offset / ORBIT_DISTANCE) ) * ORBIT_DISTANCE

func attack_enemies():
	for bee in bees:
		bee.target = enemies.back() if not enemies.is_empty() else null

func kill_bee(bee_to_kill: Bee):
	bees.pop_at(bees.find(bee_to_kill))
	bee_to_kill.queue_free()
	population -= 1

func _on_timer_timeout():
#	Spawn a bee
	print("hive timer expired")
	spawn_bee()


func _on_hive_defend_radius_entered(enemy):
	hive_state = states.AGGRO
	enemies.append(enemy)
	if enemies.size() > 1:
		enemies.sort_custom(sort_enemies)
	attack_enemies()
	print("enemy detected: " + str(enemy))


func _on_hive_defend_radius_exited(enemy):
	enemies.pop_at(enemies.find(enemy))
	if enemies.size() > 1:
		enemies.sort_custom(sort_enemies)
	print("enemy lost: " + str(enemy))
	if enemies.size() == 0:
		hive_state = states.CHILL
		home_all_bees()
		print("no enemies")
	else:
		attack_enemies()

func sort_enemies(a: Area2D, b: Area2D):
	match hive_config:
		targeting_mode.CLOSEST:
			return sort_by_closest(a, b)

func sort_by_closest(a: Area2D, b: Area2D):
	if a.get_parent().progress < b.get_parent().progress:
		return true
	else:
		return false
	
