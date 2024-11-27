class_name SpawnInfo
extends Resource

@export_range(0.0, 360, 0.1) var time_start: float
@export_range(0.0, 360, 0.1) var time_end: float
@export var enemy: Resource
@export_range(0, 999) var enemy_num: int
@export_range(0.0, 360, 0.1) var enemy_spawn_delay: float

var spawn_delay_counter: float = 0.0
