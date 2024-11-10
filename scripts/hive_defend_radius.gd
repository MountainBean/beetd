extends Area2D

@onready var radius: float = get_parent().defence_radius
@onready var collision_shape = $CollisionShape2D

func _ready():
	collision_shape.shape.radius = radius
