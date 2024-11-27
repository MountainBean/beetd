extends Area2D

class_name Hive

#---
# ENUMS
enum targeting_mode {CLOSEST}
enum temperament {PASSIVE, AGGRESSIVE}

#---
# Constants for configuring bee hover behaviour
const ORBIT_DISTANCE := 32.0
const BEE_UNIT := 11


var enemies: Array[Enemy] = []:
	set(new_array):
		enemies = new_array

# TODO: allow different targetting configurations
var hive_config := targeting_mode.CLOSEST
var population: int = 0

#---
# Hive attributes
var defence_radius : float
var cap : int
var build_cost: float

var hive_queen: Queen:
	set(new_queen):
		if new_queen != null:
			hive_queen = new_queen
			timer.wait_time = hive_queen.bee_spawn_rate

# References to child nodes
@onready var timer := $Timer
@onready var hive_defend_radius := $HiveDefendRadius
@onready var arrow_pointer = $ArrowPointer
@onready var bees = $Bees


var show_target: bool = false:
	set(value):
		show_target = value
		if arrow_pointer:
			arrow_pointer.visible = value
@onready var modifier_icon = $ModifierIcon
@onready var state_machine = $StateMachine
@onready var sprite = $Sprite2D
@onready var indicator_aggro = $IndicatorAggro


static func build_from_item(item_hive: ItemHive) -> Hive:
	#! Constructor that creates a new Hive object from a given ItemHive object
	var new_hive: Hive = item_hive.get_buildable_scene().instantiate()
	new_hive.defence_radius = item_hive.defence_radius
	new_hive.cap = item_hive.cap
	new_hive.build_cost = item_hive.item_build_cost
	return new_hive

func _ready():
	show_target = false
	indicator_aggro.visible = false

func _process(delta):
	if population < cap and timer.is_stopped():
		timer.start()
	if not enemies.is_empty():
		enemies.sort_custom(_sort_by_closest)
		arrow_pointer.global_position = enemies.back().global_position
	

func spawn_bee(queen: Queen):
	# append a new bee to the hive's bee array, increase population and home all bees
	var new_bee: Bee = Bee.new_bee(queen.bee_health, queen.bee_speed)
	new_bee.target = enemies.back() if not enemies.is_empty() else null
	bees.add_child(new_bee)
	population += 1
	state_machine.current_state.assign_bee_directions()

func kill_bee(bee_to_kill: Bee):
	bee_to_kill.queue_free.call_deferred()
	population -= 1

func _on_timer_timeout():
#	Spawn a bee
	if hive_queen != null:
		spawn_bee(hive_queen)

func _on_hive_defend_radius_entered(enemy):
	if hive_queen != null:
		if hive_queen.bee_temperament == Queen.temperament.AGGRESSIVE:
			enemies.append(enemy)

func _on_hive_defend_radius_exited(enemy):
	if enemies.has(enemy):
		enemies.pop_at(enemies.find(enemy))

func _sort_enemies(a: Node2D, b: Node2D):
	match hive_config:
		targeting_mode.CLOSEST:
			return _sort_by_closest(a, b)

func _sort_by_closest(a: Node2D, b: Node2D):
	if a.progress > b.progress:
		return true
	else:
		return false

func get_resource_count() -> float:
	if hive_queen != null:
		return population * hive_queen.bee_productivity
	else:
		return 0.0
