extends State

@onready var bee: Bee = get_parent().get_parent()

func update(_delta):
	if bee.hive.state_machine.current_state.name == "HiveAggro":
		emit_signal("transition_out", self, "Aggro")

func physics_update(delta):
	bee.move(delta)

func enemy_touched(_body):
	pass
