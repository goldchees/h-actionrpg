extends Area2D

@onready var player: CharacterBody2D = $player
@onready var hold_to_heal: Control = $holdToHeal
@onready var progress_bar: ProgressBar = $holdToHeal/MarginContainer/VBoxContainer/ProgressBar


var player_in_range: bool = false

func _ready() -> void:
	hold_to_heal.hide()
	progress_bar.value = 100

func _process(delta: float) -> void:
	if player_in_range and Input.is_action_pressed('heal') and Global.health < 100:
		hold_to_heal.show()
		progress_bar.value -= delta * 100
		if progress_bar.value <= 0:
			Global.health += 20
			print(Global.health)
			queue_free()
	else:
		hold_to_heal.hide()
		progress_bar.value = 100


func _on_body_entered(body: Node2D) -> void:
	if body.has_method('player'):
		player_in_range = true

func _on_body_exited(body: Node2D) -> void:
	if body.has_method('player'):
		player_in_range = true
