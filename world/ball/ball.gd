class_name Ball
extends Area2D

signal served()

@export var _starting_speed: float
@export var _max_speed: float
@export_range(1.01, 1.1) var _accel_rate: float

var _served: bool = false
var _velocity: Vector2 = Vector2.ZERO
var _speed: float = 0
var _starting_position: Vector2
var _server: Player.Index = Player.Index.NONE

func get_server() -> Player.Index:
	return _server

func stop():
	_velocity = Vector2.ZERO

func reset(server_index: Player.Index):
	global_position = _starting_position
	_velocity = Vector2.ZERO
	_speed = 0
	_server = server_index
	_served = false

func serve():
	if _served:
		return

	var serve_direction = Vector2.LEFT if _server == Player.Index.ONE else Vector2.RIGHT
	_speed = _starting_speed
	_velocity = serve_direction * _speed
	_served = true

	served.emit()

func _ready():
	_starting_position = global_position

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
		_speed = minf(_speed * _accel_rate, _max_speed)
	elif body.is_in_group("edge"):
		_velocity.y *= -1
