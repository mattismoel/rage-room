class_name Equipment
extends Node2D

signal was_disabled

## Here an optional struggle component can be added to limit the movement
@export var struggle_component: StruggleComponent
@export var _state_machine: StateMachine

## Emitted whenever the equipment is used.
signal used

func disable() -> void:
	_state_machine.request_disable()

func enable() -> void:
	_state_machine.request_enable()

func use(_pos: Vector2) -> void:
	used.emit()
	pass

func _process(delta: float) -> void:
	var pos: Vector2
	if struggle_component: pos = struggle_component.get_struggling_mouse_pos()
	else: pos = get_global_mouse_position()
	
	global_position = pos
