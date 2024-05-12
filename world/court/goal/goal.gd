class_name Goal
extends Node

signal goal_scored(player_index)

@export var _owner_index: Player.Index

func _on_area_entered(area: Area2D):
	if area is not Ball:
		return

	match _owner_index:
		Player.Index.ONE:
			goal_scored.emit(Player.Index.TWO)
		Player.Index.TWO:
			goal_scored.emit(Player.Index.ONE)
		_:
			# Shouldn't happen
			pass
