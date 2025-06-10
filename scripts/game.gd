extends Node2D

@onready var player: CharacterBody2D = $player
@onready var game_over_menu: Control = $CanvasLayer/gameOverMenu

func _ready() -> void:
	Global.health = 100
	player.player_death.connect(_on_player_death)
	game_over_menu.restart.connect(_on_restart)
	game_over_menu.hide()
	get_tree().paused = false
	

func _on_player_death():
	game_over_menu.show()
	if Global.health <= 0:
		get_tree().paused = true
	
func _on_restart():
	#get_tree().paused = false
	#Global.health = 100
	#game_over_menu.hide()
	get_tree().reload_current_scene()
