class_name Insect
extends Node2D

## Emitted whenever the insect is killed. It containes a reference to itself.
signal killed(insect: Insect)

@export var _target_zone: TargetZone

var _target: Target

func _ready() -> void:
	InsectManager.add([self])

	## We need to wait two physics frames for some reason...
	await get_tree().physics_frame
	await get_tree().physics_frame

	## If the insect has no target zone, it is considered target-less, and we do
	## not wish to target anything.
	if _target_zone == null:
		return

	var t := _target_zone.find_target()
	target(t)

## Targets the input target t.
func target(t: Target) -> void:
	_target = t
	pass

func kill() -> void:
	killed.emit(self)
