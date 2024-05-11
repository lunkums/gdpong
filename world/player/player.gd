class_name Player
extends AnimatableBody2D

enum Index {
	NONE = 0,
	ONE = 1,
	TWO = 2,
}

@export var _index: Index
@export var _speed: float

func _physics_process(delta: float):
	var direction = Input.get_axis("p%d_move_up" % _index, "p%d_move_down" % _index)
	var motion = Vector2(0, direction * _speed) * delta

	move_and_collide(motion)

