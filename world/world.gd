class_name World
extends Node

signal reset()

@onready var player_1: Player = $Player1
@onready var player_2: Player = $Player2
@onready var ball: Ball = $Ball
@onready var reset_timer: Timer = $ResetTimer

func _ready():
	for goal in get_tree().get_nodes_in_group("goal"):
		if goal is Goal:
			goal.goal_scored.connect(_on_goal_scored)

func _input(event: InputEvent):
	if event.is_action_pressed("game_exit"):
		get_tree().quit()
	if event.is_action_pressed("game_reset"):
		get_tree().reload_current_scene()

func _on_goal_scored(player_index: Player.Index):
	print("Player %d scored!" % player_index)
	reset_timer.start()

func _on_reset_timer_timeout():
	player_1.reset()
	player_2.reset()
	ball.reset()
	reset.emit()
