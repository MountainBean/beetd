extends State

@onready var bee: Bee = get_parent().get_parent()

func physics_update(delta):
	bee.move(delta)

func update(_delta):
	if bee.target != null:
		# set home to the target position relative to the hive
		bee.home = bee.hive.to_local(bee.target.global_position)
	if bee.hive.state_machine.current_state.name == "HiveChill":
		emit_signal("transition_out", self, "Chill")

func enemy_touched(body):
	bee.stung = true
	body.die()
	bee.die()
