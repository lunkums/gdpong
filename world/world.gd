class_name World
extends Node

signal reset()
signal round_ended(scorer_index)
signal game_ended(winner_index)

@onready var player_1: Player = $Player1
@onready var player_2: Player = $Player2
@onready var ball: Ball = $Ball
@onready var reset_timer: Timer = $ResetTimer

@export var _winning_score: int

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
	if player_1.get_score() >= _winning_score:
		game_ended.emit(player_index)
	elif player_2.get_score() >= _winning_score:
		game_ended.emit(player_index)
	else:
		reset_timer.start()
		round_ended.emit(player_index)

func _on_reset_timer_timeout():
	player_1.reset()
	player_2.reset()
	ball.reset()
	reset.emit()
