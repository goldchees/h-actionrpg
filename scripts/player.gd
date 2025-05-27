extends CharacterBody2D

enum States {IDLE, WALK, ATTACK}

var current_state: States = States.IDLE

@onready var animatedSprite2d := $AnimatedSprite2D
@onready var animationPlayer := $AnimationPlayer
@onready var attackArea := $attackArea
@onready var knockbackTimer := $knockbackTimer
var speed := 100
var player_facing: String
var knockbackPower: int = 100
var get_knockback: bool = false

func _ready() -> void:
	player_facing = "down"
	scale = Vector2(1,1)

func _physics_process(delta: float) -> void:
	match current_state:
		States.IDLE:
			do_idle()
		States.WALK:
			do_walk()
		States.ATTACK:
			do_attack()

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
	var dir := Input.get_vector("left","right","up","down")
	velocity = speed * dir
	if dir == Vector2.ZERO and current_state == States.WALK:
		current_state = States.IDLE
	move_and_slide()

func do_attack():
	if player_facing == "right" or player_facing == "left":
		animationPlayer.play("side_attack")
	elif player_facing == "up":
		animationPlayer.play("f_attack")
	elif player_facing == "down":
		animationPlayer.play("b_attack")
	velocity = -velocity
	move_and_slide()
	#speed = 50
	#move()

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

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.has_method("enemy") and current_state == States.ATTACK:
		body.damage(velocity)
		print("attack")

func player():
	pass


func _on_knockback_timer_timeout() -> void:
	get_knockback = false
