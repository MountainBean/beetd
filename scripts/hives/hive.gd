extends Area2D

class_name Hive

#---
# ENUMS
enum states {CHILL, AGGRO}
enum targeting_mode {CLOSEST}
enum temperament {PASSIVE, AGGRESSIVE}

#---
# Constants for configuring bee hover behaviour
const ORBIT_DISTANCE := 32.0
const BEE_UNIT := 12

# TODO: remove bee array. not needed as all bees are chilren of the hive
var bees: Array[Bee] = []
var enemies: Array[Area2D] = []

# TODO: allow different targetting configurations
var hive_config := targeting_mode.CLOSEST
var population: int = 0

# When the hive state is changed, update all children bees to the same state
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

#---
# Hive attributes
var defence_radius : float
var spawn_rate : float
var cap : int
var bee_productivity: float
var bee_temperament: temperament
var build_cost: float

#---
# Bee attributes
var bee_health: int
var bee_speed: float

var modifier_icon_texture: Texture

@onready var timer := $Timer
@onready var hive_defend_radius := $HiveDefendRadius
@onready var arrow_pointer = $ArrowPointer
@onready var modifier_icon = $ModifierIcon

static func build_from_item(item_hive: ItemHive) -> Hive:
	var new_hive: Hive = item_hive.get_buildable_scene().instantiate()
	new_hive.defence_radius = item_hive.defence_radius
	new_hive.spawn_rate =  item_hive.spawn_rate
	new_hive.cap = item_hive.cap
	new_hive.bee_productivity = item_hive.bee_productivity
	new_hive.bee_temperament = item_hive.bee_temperament
	new_hive.build_cost = item_hive.build_cost
	new_hive.bee_health = item_hive.bee_health
	new_hive.bee_speed = item_hive.bee_speed
	new_hive.modifier_icon_texture = item_hive.modifier_icon
	return new_hive

func _ready():
	timer.wait_time = 1 / spawn_rate
	arrow_pointer.visible = false
	modifier_icon.texture = modifier_icon_texture

func _process(delta):
	if bees.size() < cap and timer.is_stopped():
		timer.start()
	if not enemies.is_empty():
		arrow_pointer.global_position = enemies.back().global_position

func spawn_bee():
	# append a new bee to the hive's bee array, increase population and home all bees
	var new_bee: Bee = Bee.new_bee(bee_health, bee_speed)
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
	spawn_bee()


func _on_hive_defend_radius_entered(enemy):
	if bee_temperament == temperament.AGGRESSIVE:
		hive_state = states.AGGRO
		enemies.append(enemy)
		if enemies.size() > 1:
			enemies.sort_custom(sort_enemies)
		attack_enemies()


func _on_hive_defend_radius_exited(enemy):
	if bee_temperament == temperament.AGGRESSIVE:
		enemies.pop_at(enemies.find(enemy))
		if enemies.size() > 1:
			enemies.sort_custom(sort_enemies)
		if enemies.size() == 0:
			hive_state = states.CHILL
			home_all_bees()
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

func get_resource_count() -> float:
	if bee_productivity == 0:
		pass
	return bees.size() * bee_productivity
