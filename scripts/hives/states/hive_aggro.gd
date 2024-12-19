extends State

@onready var hive: Hive = get_parent().get_parent()

func rehome_bees():
	pass
	
func assign_bee_directions():
	var total_enemies = hive.enemies.size()
	for bee in hive.bees.get_children():
		bee.set_target_with_delay(hive.enemies[-1] if not hive.enemies.is_empty() else null)

func enter():
	hive.indicator_aggro.visible = true
	hive.show_target = true

func update(_delta):
	if hive.enemies.size() == 0:
		emit_signal("transition_out", self, "HiveChill")
	else:
		assign_bee_directions()
