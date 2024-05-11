extends Node

@onready var player_1: Player = $Player1
@onready var player_2: Player = $Player2

func _input(event: InputEvent):
	if (event.is_action_pressed("game_exit")):
		get_tree().quit()
	if (event.is_action_pressed("game_reset")):
		get_tree().reload_current_scene()

