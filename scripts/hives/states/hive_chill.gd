extends State

@onready var hive: Hive = get_parent().get_parent()

func assign_bee_directions():
	for i in range(hive.population):
		var home_offset = ( 0.5 * ( 1 - hive.population ) + i ) * hive.BEE_UNIT
		hive.bees.get_child(i).home = Vector2.from_angle( ( -PI / 2 ) + (home_offset / hive.ORBIT_DISTANCE) ) * hive.ORBIT_DISTANCE

func enter():
	hive.indicator_aggro.visible = false
	hive.show_target = false
	assign_bee_directions()

func update(delta):
	if hive.enemies.size() > 0:
		emit_signal("transition_out", self, "HiveAggro")
