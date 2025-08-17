class_name Equipment
extends Node2D

signal was_disabled

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
