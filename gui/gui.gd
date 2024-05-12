extends Control

@onready var _p1_score: Label = $HBoxContainer/Score
@onready var _p2_score: Label = $HBoxContainer/Score2
@onready var _log: Label = $Log

func _ready():
	for player in get_tree().get_nodes_in_group("player"):
		if player is Player:
			player.score_changed.connect(_on_player_score_changed)

	var world = get_tree().get_first_node_in_group("world")
	if world is World:
		world.reset.connect(_on_world_reset)

func _set_log(message: String):
	_log.text = message

func _on_player_score_changed(index: Player.Index, new_score: int):
	match index:
		Player.Index.ONE:
			_p1_score.text = str(new_score)
			_set_log("Player 1 scored! Resetting...")
		Player.Index.TWO:
			_p2_score.text = str(new_score)
			_set_log("Player 2 scored! Resetting...")
		_:
			# Shouldn't happen
			pass

func _on_world_reset():
	_set_log("")

