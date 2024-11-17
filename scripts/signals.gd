extends Node

signal place_mode()
signal view_mode()
signal mode_just_changed(mode: GameManager.game_modes)
signal hive_created(coords: Vector2i)
signal resource_count_updated(new_resource_value: int)
signal build_at_global_pos(global_position: Vector2)
signal place_queen_in_hive(queen: Queen, hive: Hive)
