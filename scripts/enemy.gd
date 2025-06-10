extends CharacterBody2D

enum States {idle, chase, attack, hurt}
var current_state = States.idle
@onready var animationPlayer := $AnimationPlayer
@onready var player := $"../player"
@onready var hitParticles := $hitParticles
@onready var attackTimer := $attackTimer

var player_in_range := false
var dir: Vector2
var speed: int = 50

var knockback: Vector2
var min_knockback := 100
var slow_knockback := 1.1

var health: int = 30
var can_attack: bool = true
var in_attack_range: bool = false

func _ready() -> void:
	animationPlayer.play("RESET")
	health = 30
	scale.x = 1

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	match current_state:
		States.idle:
			do_idle()
		States.chase:
			do_chase()
		States.attack:
			do_attack()
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
	for child in get_children():
		if child is Node2D:
			if dir < Vector2.ZERO:
				child.scale.x = 1
			else:
				child.scale.x = -1
	move_and_slide()



func do_hurt():
	if knockback.length() > min_knockback:
		knockback /= slow_knockback
		velocity = knockback
		move_and_slide()
	else:
		check_if_dead()
		current_state = States.idle

func damage(player_vel):
	current_state = States.hurt
	animationPlayer.play("damage")
	knockback = (position - player.position).normalized() * 200
	hitParticles.restart()
	hitParticles.rotation = player.global_position.angle_to_point(global_position)
	hitParticles.emitting = true
	health -= 10

func do_attack():
	if can_attack and in_attack_range:
		player.take_damage(self)
		can_attack = false
		attackTimer.start()


func enemy():
	pass


func _on_detect_range_body_entered(body: Node2D) -> void:
	if body.has_method('player'):
		player_in_range = true



func _on_detect_range_body_exited(body: Node2D) -> void:
	if body.has_method('player'):
		player_in_range = false
		

func check_if_dead():
	if health <= 0:
		queue_free()


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.has_method('player'):
		in_attack_range = true
		print('in range')
		current_state = States.attack
		


func _on_attack_timer_timeout() -> void:
	can_attack = true


func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.has_method('player'):
		in_attack_range = false
		print('not in range')
		current_state = States.idle
		
