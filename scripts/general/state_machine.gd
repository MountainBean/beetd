class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready():
	await get_parent().ready
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition_out.connect(_on_child_transition)
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func _on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state: State = states.get(new_state_name)
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
