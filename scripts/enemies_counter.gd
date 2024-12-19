extends Label

func _ready():
	Signals.connect("enemy_killed", _on_enemy_killed_or_spawned)
	Signals.connect("enemy_spawned", _on_enemy_killed_or_spawned)

func _on_enemy_killed_or_spawned(_enemy):
	text = "ENEMIES: " + str(GameManager.enemy_total)
