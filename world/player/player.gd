class_name Player
extends AnimatableBody2D

enum Index {
	NONE = 0,
	ONE = 1,
	TWO = 2,
}

signal score_changed(index, new_score)

@export var _index: Index
@export_range(200, 400) var _speed: float

var _score: int = 0
var _starting_position: Vector2

func reset():
	global_position = _starting_position
	set_physics_process(false)

func _ready():
	_starting_position = global_position
	set_physics_process(false)

	for goal in get_tree().get_nodes_in_group("goal"):
		if goal is Goal:
			goal.goal_scored.connect(_on_goal_scored)

	var ball = get_tree().get_first_node_in_group("ball")
	if ball is Ball:
		ball.served.connect(_on_ball_served)

func _physics_process(delta: float):
	var direction = Input.get_axis("p%d_move_up" % _index, "p%d_move_down" % _index)
	var motion = Vector2(0, direction * _speed) * delta

	move_and_collide(motion)

func _on_goal_scored(player_index: Index):
	if player_index == _index:
		_score += 1
		score_changed.emit(_index, _score)

func _on_ball_served():
	set_physics_process(true)
