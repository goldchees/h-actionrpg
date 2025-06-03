extends CharacterBody2D

enum States {IDLE, WALK, ATTACK}

var current_state: States = States.IDLE

@onready var animatedSprite2d := $AnimatedSprite2D
@onready var animationPlayer := $AnimationPlayer
@onready var attackArea := $attackArea
@onready var hurtTimer := $hurtTimer
var speed := 100
var player_facing: String
var dir: Vector2

var can_attack: bool = true

var min_knockback := 50
var slow_knockback := 1.6
var knockback: Vector2

var health: int = 50
var can_take_damage: bool = true

func _ready() -> void:
	player_facing = "down"
	scale = Vector2(1,1)

func _physics_process(delta: float) -> void:
	check_knockback()
	match current_state:
		States.IDLE:
			do_idle()
		States.WALK:
			do_walk()
		States.ATTACK:
			do_attack(delta)

func do_idle():
	if player_facing == "right" or player_facing == "left":
		animatedSprite2d.play("side_idle")
		flip()
	elif player_facing == "up":
		animatedSprite2d.play("f_idle")
	elif player_facing == "down":
		animatedSprite2d.play("b_idle")
	if Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
		current_state = States.WALK
	check_if_attack()

func do_walk():
	if Input.is_action_pressed("right") or Input.is_action_pressed("left"):
		flip()
		if Input.is_action_pressed("right"):
			player_facing = "right"
		elif Input.is_action_pressed("left"):
			player_facing = "left"
		animatedSprite2d.play("side_walk")
	elif Input.is_action_pressed("up"):
		animatedSprite2d.play("f_walk")
		player_facing = "up"
	elif Input.is_action_pressed("down"):
		animatedSprite2d.play("b_walk")
		player_facing = "down"
	speed = 100
	check_if_attack()
	move()
	
func move():
	dir = Input.get_vector("left","right","up","down")
	velocity = speed * dir
	if dir == Vector2.ZERO and current_state == States.WALK:
		current_state = States.IDLE
	move_and_slide()

func do_attack(delta):
	if player_facing == "right" or player_facing == "left":
		animationPlayer.play("side_attack")
	elif player_facing == "up":
		animationPlayer.play("f_attack")
	elif player_facing == "down":
		animationPlayer.play("b_attack")

func check_knockback():
	if knockback.length() > min_knockback: 
		knockback /= slow_knockback 
		velocity = knockback 
		move_and_slide() 
		return 

func check_dir():
	if Input.is_action_just_pressed("right"):
		player_facing = "right"
	elif Input.is_action_just_pressed("left"):
		player_facing = "left"
	elif Input.is_action_just_pressed("up"):
		player_facing = "up"
	elif Input.is_action_just_pressed("down"):
		player_facing = "down"

func check_if_attack():
	if Input.is_action_just_pressed("attack"):
		current_state = States.ATTACK
		
func flip():
	if player_facing == "right":
		animatedSprite2d.flip_h = false
		attackArea.scale.x = 1
	if player_facing == "left":
		animatedSprite2d.flip_h = true
		attackArea.scale.x = -1

func finished_attack():
	if current_state == States.ATTACK:
		current_state = States.IDLE
		can_attack = true

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.has_method("enemy") and current_state == States.ATTACK and can_attack:
		body.damage(velocity)
		print("attack")
		knockback = (position - body.position).normalized() * 200
		can_attack = false

func take_damage(enemy):
	if can_take_damage:
		print('taking damage')
		#animationPlayer.play("hurt")
		# instead of using hurt animation, use tween bc can't play 2 anim at same time
		animatedSprite2d.modulate = Color.RED
		var tween = create_tween()
		tween.tween_property(animatedSprite2d, 'modulate', Color.WHITE, 0.5)
		#tween.play()
		if tween.is_running():
			print('tween running')
		knockback = (position - enemy.position).normalized() * 400
		hurtTimer.start()
		can_take_damage = false

func player():
	pass


func _on_hurt_timer_timeout() -> void:
	can_take_damage = true
