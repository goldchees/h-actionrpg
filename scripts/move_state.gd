#extends state
#class_name Move
#
#var move_speed := 150
#
#func Enter():
	#animated_sprite.play("b_walk")
#
#func Exit():
	#pass
#
#func Update(delta: float):
	#var input = Input.get_vector("left", "right", "up", "down")
	#if input == Vector2.ZERO:
		#var idle_state = get_parent().states.get("idle")
		#emit_signal("state_transition", self, idle_state)
		#return
#
	#var player = get_parent().get_parent()  # Assuming Player is the parent of the StateMachine
	#player.velocity = input.normalized() * move_speed
extends state
class_name Move

var speed := 150

func Enter():
	print("Entered Move State")

func Exit():
	print("Leaving Move State")

func Update(delta):
	#finish walk
	var input = Input.get_vector("left", "right", "up", "down")
