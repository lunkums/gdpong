extends Control

@onready var _p1_score: Label = $HBoxContainer/Score
@onready var _p2_score: Label = $HBoxContainer/Score2
@onready var _log: Label = $Log
@onready var _title: Label = $Title

func _ready():
	for player in get_tree().get_nodes_in_group("player"):
		if player is Player:
			player.score_changed.connect(_on_player_score_changed)

	var world = get_tree().get_first_node_in_group("world")
	if world is World:
		world.reset.connect(_on_world_reset)
		world.round_ended.connect(_on_round_ended)
		world.game_started.connect(_on_game_started)
		world.game_ended.connect(_on_game_ended)
		world.ball_exited_bounds.connect(_on_ball_exited_bounds)

	var ball = get_tree().get_first_node_in_group("ball")
	if ball is Ball:
		ball.served.connect(_on_ball_served)

func _set_log(message: String):
	_log.text = message

func _hide_title():
	_title.hide()

func _on_player_score_changed(index: Player.Index, new_score: int):
	match index:
		Player.Index.ONE:
			_p1_score.text = str(new_score)
		Player.Index.TWO:
			_p2_score.text = str(new_score)
		_:
			# Shouldn't happen
			pass

func _on_round_ended(scorer_index: Player.Index):
	_set_log("Player %d scores! Resetting..." % scorer_index)

func _on_game_started():
	_hide_title()

func _on_game_ended(winner_index: Player.Index):
	_set_log("Player %d has won! Press R to restart." % winner_index)

func _on_world_reset(server_index: Player.Index):
	match server_index:
		Player.Index.ONE:
			_set_log("Player 1 is serving! Press A to serve.")
		Player.Index.TWO:
			_set_log("Player 2 is serving! Press RIGHT ARROW to serve.")
		_:
			# Shouldn't happen
			pass

func _on_ball_served():
	_set_log("")

func _on_ball_exited_bounds():
	_set_log("Ball out of bounds! Resetting...")
