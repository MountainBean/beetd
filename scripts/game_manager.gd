extends Node

enum game_modes {VIEW, PLACE}

var tiles: Dictionary = {}

var mode = game_modes.VIEW:
	set(new_mode):
		if mode != new_mode:
			mode = new_mode
			Signals.emit_signal("mode_just_changed", new_mode)
			match mode:
				game_modes.VIEW:
					print("Switched to VIEW mode")
				game_modes.PLACE:
					print("Switched to PLACE mode")

var curr_buildable: Resource

func _ready():
	Signals.connect("place_mode", _on_place_mode)
	Signals.connect("view_mode", _on_view_mode)

func _on_place_mode(buildable: Resource):
	curr_buildable = buildable
	mode = game_modes.PLACE

func _on_view_mode():
	mode = game_modes.VIEW
