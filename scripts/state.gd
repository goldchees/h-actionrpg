#extends Node
#class_name state
#
#@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
#@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
#
#
#signal state_transition(old_state: state, new_state: state)
#
#func Enter():
	#pass
#
#func Exit():
	#pass
	#
#func Update(_delta:float):
	#pass
# State.gd
extends Node
class_name state

var state_machine

func Enter():
	pass  # called when state is entered

func Exit():
	pass  # called when state is exited

func Update(_delta: float):
	pass  # called every frame
