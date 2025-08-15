class_name Equipment
extends Node2D

## Here an optional struggle component can be added to limit the movement
@export var struggle_component: StruggleComponent

## Emitted whenever the equipment is used.
signal used

func use(_pos: Vector2) -> void:
	used.emit()
	pass

func _process(delta: float) -> void:
	var pos: Vector2
	if struggle_component: pos = struggle_component.get_struggling_mouse_pos()
	else: pos = get_global_mouse_position()
	
	global_position = pos
