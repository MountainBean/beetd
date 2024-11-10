extends PathFollow2D

@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 100
var last_x = position.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	last_x = position.x
	move(delta)
	if position.x - last_x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	

func die():
	queue_free()

func move(delta):
	progress += SPEED * delta
