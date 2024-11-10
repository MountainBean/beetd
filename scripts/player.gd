extends CharacterBody2D


const SPEEDX = 300.0
const TILEX = 108
const TILEY = 54
const SPEEDY = SPEEDX * TILEY / TILEX



func _physics_process(delta):
	
	if Input.is_action_just_pressed("view_mode"):
		Signals.emit_signal("view_mode")

	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))

	if direction:
		velocity.x = direction.normalized().x * SPEEDX
		velocity.y = direction.normalized().y * SPEEDY
	else:
		velocity.x = move_toward(velocity.x, 0, SPEEDX)
		velocity.y = move_toward(velocity.y, 0, SPEEDY)

	move_and_slide()
