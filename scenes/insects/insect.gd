class_name Insect
extends Node2D

## Emitted whenever the insect takes a bite. It contains the amount of damage 
## dealt.
signal took_bite(damage: float)

## Emitted whenever the insect is killed. It containes a reference to itself.
signal killed(insect: Insect)

## The amount of damage per bite.
@export var damage: float = 1.0

@export var _target_zone: TargetZone

func _ready() -> void:
	InsectManager.add([self])

	## We need to wait two physics frames for some reason...
	await get_tree().physics_frame
	await get_tree().physics_frame


	## If the insect has no target zone, it is considered target-less, and we do
	## not wish to target anything.
	if _target_zone == null:
		return

	_target_zone.area_entered.connect(_on_area_entered)
	var t := _target_zone.find_target()

	target(t)

## Targets the input target t. 
## This must be implemented by the descendant.
func target(t: Target) -> void:
	assert(false, "The 'target()' method must be implemented by descendant!")
	pass

func kill() -> void:
	killed.emit(self)

func _on_area_entered(area: Area2D) -> void:
	pass
