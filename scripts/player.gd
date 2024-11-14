extends CharacterBody2D

const SPEEDX = 300.0
const TILEX = 108
const TILEY = 54
const SPEEDY = SPEEDX * TILEY / TILEX
@onready var ui = $UI


func _ready():
	ui.inventory_panel.visible = false
		

func _physics_process(delta):
	if Input.is_action_just_pressed("view_mode"):
		Signals.emit_signal("view_mode")
	if Input.is_action_just_pressed("open_inventory"):
		ui.inventory_panel.visible = not ui.inventory_panel.visible
	if Input.is_action_just_pressed("close_menu"):
		ui.inventory_panel.visible = false
	if Input.is_action_just_released("LMB"):
		if GameManager.mode == GameManager.game_modes.PLACE and not ui.inventory_panel.visible:
			Signals.emit_signal("build_at_global_pos", get_global_mouse_position())


	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))

	if direction:
		velocity.x = direction.normalized().x * SPEEDX
		velocity.y = direction.normalized().y * SPEEDY
	else:
		velocity.x = move_toward(velocity.x, 0, SPEEDX)
		velocity.y = move_toward(velocity.y, 0, SPEEDY)
	GameManager.player_pos = position
	move_and_slide()
