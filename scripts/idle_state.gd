#extends state
#class_name idle
#
#
#func Enter():
	#animated_sprite.play("b_idle")
#
#func Exit():
	#pass
	#
#func Update(_delta:float):
	#if Input.get_vector("left","right","up","down") != Vector2.ZERO:
		#var move_state = get_parent().states.get("move")
		#emit_signal("state_transition", self, move_state)
extends state
class_name Idle

func Enter():
	print("Entered Idle")

func Update(_delta):
	print("update idle")
	
	if Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
		state_machine.change_state("moveState")
	elif Input.is_action_just_pressed("dash"):
		state_machine.change_state("Dash")
