extends State

@onready var hive: Hive = get_parent().get_parent()
const BEE_STATE := Bee.states.AGGRO

func rehome_bees():
	pass
	
func assign_bee_directions():
	for bee in hive.bees:
		bee.target = hive.enemies.back() if not hive.enemies.is_empty() else null

func enter():
	print("Hive becomes aggro")
	hive.show_target = true
	for bee in hive.bees:
		bee.bee_state = 1 as Bee.states
	assign_bee_directions()

func update(_delta):
	if hive.enemies.size() == 0:
		emit_signal("transition_out", self, "HiveChill")
