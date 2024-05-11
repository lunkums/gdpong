class_name Ball
extends CharacterBody2D

@export var _starting_speed: float

var _served: bool = false

func _serve():
	if (_served):
		return

	velocity.x = _starting_speed
	_served = true

func _input(event: InputEvent):
	if (event.is_action_pressed("ball_serve")):
		_serve()

func _physics_process(delta: float):
	move_and_slide()
