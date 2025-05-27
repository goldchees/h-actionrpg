extends CharacterBody2D

@onready var animationPlayer := $AnimationPlayer
@onready var player := $"../player"
@onready var knockbackTimer := $knockBackTimer
var player_in_range := false
var dir: Vector2
var speed: int = 50
var knockbackPower: int = 200
var get_knockback: bool = false

func _ready() -> void:
	animationPlayer.play("RESET")

func _physics_process(delta: float) -> void:
	if player_in_range:
		var player_pos = player.global_position
		dir = (player_pos - global_position).normalized()
		velocity = dir * speed
	if get_knockback:
		dir = (player.velocity - velocity).normalized() 
		velocity = dir * knockbackPower
	move_and_slide()

func damage(player_vel):
	animationPlayer.play("damage")
	get_knockback = true
	knockbackTimer.start()

func enemy():
	pass


func _on_detect_range_body_entered(body: Node2D) -> void:
	if body.has_method('player'):
		player_in_range = true


func _on_detect_range_body_exited(body: Node2D) -> void:
	if body.has_method('player'):
		player_in_range = false


func _on_knock_back_timer_timeout() -> void:
	get_knockback = false
