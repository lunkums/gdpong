class_name World
extends Node

signal reset(server_index)
signal round_ended(scorer_index)
signal game_started()
signal game_ended(winner_index)

@onready var player_1: Player = $Player1
@onready var player_2: Player = $Player2
@onready var ball: Ball = $Ball
@onready var reset_timer: Timer = $ResetTimer

@export var _winning_score: int

var _game_over: bool = false
var _serving_offset: int

func _get_server() -> Player.Index:
	var total_score = player_1.get_score() + player_2.get_score()
	return Player.Index.ONE if (_serving_offset + total_score) % 4 < 2 else Player.Index.TWO

func _ready():
	_serving_offset = randi_range(0, 1) * 2

	for goal in get_tree().get_nodes_in_group("goal"):
		if goal is Goal:
			goal.goal_scored.connect(_on_goal_scored)

func _input(event: InputEvent):
	if event.is_action_pressed("game_exit"):
		get_tree().quit()

	if ball.get_server() == Player.Index.NONE and event.is_action_pressed("game_select"):
		_reset()
		game_started.emit()
	if ball.get_server() == Player.Index.ONE and event.is_action_pressed("p1_serve"):
		ball.serve()
	if ball.get_server() == Player.Index.TWO and event.is_action_pressed("p2_serve"):
		ball.serve()
	if _game_over and event.is_action_pressed("game_reset"):
		get_tree().reload_current_scene()

func _on_goal_scored(player_index: Player.Index):
	if player_1.get_score() >= _winning_score:
		_end_game(player_index)
	elif player_2.get_score() >= _winning_score:
		_end_game(player_index)
	else:
		reset_timer.start()
		round_ended.emit(player_index)

func _end_game(player_index: Player.Index):
	game_ended.emit(player_index)
	_game_over = true

func _reset():
	player_1.reset()
	player_2.reset()

	var server = _get_server()
	ball.reset(server)

	reset.emit(server)
