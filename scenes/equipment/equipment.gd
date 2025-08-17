class_name Equipment
extends Node2D

## Emitted whenever the equipment is used.
signal used

func use(_pos: Vector2) -> void:
	used.emit()
	pass
