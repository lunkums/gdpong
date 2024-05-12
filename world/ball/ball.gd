class_name Ball
extends Area2D

signal served()

@export var _starting_speed: float
@export_range(1.01, 1.1) var _accel_rate: float

var _served: bool = false
var _velocity: Vector2 = Vector2.ZERO
var _speed: float = 0
var _starting_position: Vector2

func reset():
	global_position = _starting_position
	_velocity = Vector2.ZERO
	_speed = 0
	_served = false

func _serve():
	if _served:
		return

	_speed = _starting_speed
	_velocity.x = _speed
	_served = true

	served.emit()

func _ready():
	_starting_position = global_position

func _input(event: InputEvent):
	if event.is_action_pressed("ball_serve"):
		_serve()

func _physics_process(delta: float):
	move_local_x(_velocity.x * delta)
	move_local_y(_velocity.y * delta)

func _on_body_entered(body: Node2D):
	if body is Player:
		var diag_vec = Vector2(1, 1).normalized()
		var deflect = (global_position - body.global_position).normalized()

		# Limit the deflect vector

		if absf(deflect.y) > diag_vec.y:
			deflect.x = signf(deflect.x) * diag_vec.x
			deflect.y = signf(deflect.y) * diag_vec.y

		_velocity = deflect * _speed
		_speed *= _accel_rate
	elif body.is_in_group("edge"):
		_velocity.y *= -1
