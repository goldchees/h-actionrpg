extends CharacterBody2D

var dir
var speed := 200
@onready var animatedSprite2D := $AnimatedSprite2D
@onready var animationPlayer := $AnimationPlayer

#var main_sm: LimboHSM
#
#func _ready() -> void:
	#

#func _process(delta: float) -> void:
	#if velocity.x > 0:
		#animatedSprite2D.flip_h = false
	#elif velocity.x < 0:
		#animatedSprite2D.flip_h = true
	
#func _physics_process(delta: float) -> void:
	#dir = Input.get_vector("left", "right", "up", "down")
	#velocity = dir * speed
	#move_and_slide()
#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_released("dash"):
		#main_sm.dispatch(&"to_dash")
	#elif event.is_action_released("attack"):
		#main_sm.dispatch(&"to_attack")
#
#func initiate_state_machine():
	## create state machine
	#main_sm = LimboHSM.new()
	#add_child(main_sm)
	#
	## create states
	#var idle_state = LimboState.new().named("idle").call_on_enter(idle_start).call_on_update(idle_update)
	#var walk_state = LimboState.new().named("walk").call_on_enter(walk_start).call_on_update(walk_update)
	#var dash_state = LimboState.new().named("dash").call_on_enter(dash_start).call_on_update(dash_update)
	#var attack_state = LimboState.new().named("attack").call_on_enter(attack_start).call_on_update(attack_update)
#
	## add states to state machine
	#main_sm.add_child(idle_state)
	#main_sm.add_child(walk_state)
	#main_sm.add_child(dash_state)
	#main_sm.add_child(attack_state)
	#
	## set initial state to idle state
	#main_sm.initial_state = idle_state
	#
	## add transitions
	#main_sm.add_transition(idle_state, walk_state, &"to_walk")
	#main_sm.add_transition(main_sm.ANYSTATE, idle_state, &"state_ended")
	#main_sm.add_transition(walk_state, dash_state, &"to_dash")
	#main_sm.add_transition(idle_state, dash_state, &"to_dash")
	#main_sm.add_transition(main_sm.ANYSTATE, attack_state, &"to_attack")
	#
	#main_sm.initialize(self)
	#main_sm.set_active(true)
#
#func idle_start():
	#animatedSprite2D.play("b_idle")
#
#func idle_update(delta: float):
	#if velocity != Vector2.ZERO:
		#main_sm.dispatch(&"to_walk")
#
#func walk_start():
	#animatedSprite2D.play("b_walk")
#
#func walk_update(delta: float):
	#if velocity == Vector2.ZERO:
		#main_sm.dispatch(&"state_ended")
#
#func dash_start():
	#pass
#
#func dash_update(delta: float):
	#pass
#
#func  attack_start():
	#pass
#
#func attack_update(delta: float):
	#pass
