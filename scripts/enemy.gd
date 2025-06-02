extends CharacterBody2D

enum States {idle, chase, attack, hurt}
var current_state = States.idle
@onready var animationPlayer := $AnimationPlayer
@onready var player := $"../player"
@onready var hitParticles := $hitParticles
var player_in_range := false
var dir: Vector2
var speed: int = 50

var knockback: Vector2
var min_knockback := 100
var slow_knockback := 1.1

func _ready() -> void:
	animationPlayer.play("RESET")

func _physics_process(delta: float) -> void:
	match current_state:
		States.idle:
			do_idle()
		States.chase:
			do_chase()
		States.attack:
			pass
		States.hurt:
			do_hurt()

func do_idle():
	if player_in_range:
		current_state = States.chase
		
func do_chase():
	var player_pos = player.global_position
	if player_in_range:
		dir = (player_pos - global_position).normalized()
		velocity = dir * speed
	elif player_in_range == false:
		current_state = States.idle
	move_and_slide()

func do_hurt():
	if knockback.length() > min_knockback:
		knockback /= slow_knockback
		velocity = knockback
		move_and_slide()
	else:
		current_state = States.idle

func damage(player_vel):
	current_state = States.hurt
	animationPlayer.play("damage")
	knockback = (position - player.position).normalized() * 200
	hitParticles.restart()
	hitParticles.rotation = player.global_position.angle_to_point(global_position)
	hitParticles.emitting = true


func enemy():
	pass


func _on_detect_range_body_entered(body: Node2D) -> void:
	if body.has_method('player'):
		player_in_range = true


func _on_detect_range_body_exited(body: Node2D) -> void:
	if body.has_method('player'):
		player_in_range = false
