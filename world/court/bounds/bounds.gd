class_name Bounds
extends Area2D

signal ball_exited()

func _on_area_exited(area: Area2D):
	if area is Ball:
		area.stop()
		ball_exited.emit()
