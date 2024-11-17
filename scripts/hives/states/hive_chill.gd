extends State

@onready var hive: Hive = get_parent().get_parent()
const BEE_STATE := Bee.states.CHILL

func assign_bee_directions():
	for i in range(hive.population):
		var home_offset = ( 0.5 * ( 1 - hive.population ) + i ) * hive.BEE_UNIT
		hive.bees[i].home = Vector2.from_angle( ( -PI / 2 ) + (home_offset / hive.ORBIT_DISTANCE) ) * hive.ORBIT_DISTANCE

func enter():
	print("Hive becomes chill")
	hive.show_target = false
	for bee in hive.bees:
		bee.bee_state = 0 as Bee.states
	assign_bee_directions()

func update(delta):
	if hive.enemies.size() > 0:
		emit_signal("transition_out", self, "HiveAggro")
