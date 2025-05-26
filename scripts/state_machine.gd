#extends Node
#class_name state_machine
#
#var states: Dictionary = {}
#@export var initial_state: state
#
#var current_state: state
#
#func _ready() -> void:
	#for child in get_children():
		#if child is state:
			#states[child.name.to_lower()] = child
			#child.state_transition.connect(change_state)
	#if initial_state:
		#initial_state.Enter()
		#current_state = initial_state
#
#func change_state(old_state: state, new_state: state):
	#if current_state:
		#current_state.Exit()
	#new_state.Enter()
	#current_state = new_state
#
#func _process(delta: float) -> void:
	#if current_state:
		#current_state.Update(delta)
# StateMachine.gd
extends Node
class_name StateMachine

var states: Dictionary = {}
@export var initial_state: state  # Drag your initial state here in the inspector

var current_state: state

func _ready() -> void:
	# Auto-collect all child states
	for child in get_children():
		if child is state:
			var state_name := child.name.to_lower()
			states[state_name] = child
			child.state_machine = self  # <<< THIS IS IMPORTANT

	if initial_state:
		current_state = initial_state
		current_state.Enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func change_state(new_state_name: String) -> void:
	# change state
	var new_state = states.get(new_state_name.to_lower())
	if new_state == null:
		push_error("State not found: %s" % new_state_name)
		return

	if current_state:
		current_state.Exit()

	current_state = new_state
	current_state.Enter()
