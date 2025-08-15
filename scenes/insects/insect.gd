class_name Insect
extends Node2D

## Emitted whenever the insect takes a bite. It contains the amount of damage 
## dealt.
signal took_bite(damage: float)

## Emitted whenever the insect is killed. It containes a reference to itself.
signal killed(insect: Insect)

## This value will be increased if the insect is slowed down (e.g. by the spray)
var slow_down_multiplier: float = 1.0

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
func target(_t: Target) -> void:
	assert(false, "The 'target()' method must be implemented by descendant!")
	pass

## This function must be implemented in the specific insect to slow down properly
func slow_down() -> void:
	assert(false, "The 'slow_down()' method must be implemented by descendant!")
	pass

func kill() -> void:
	killed.emit(self)

func spray(slow_down: float, health_damage: float) -> void:
	slow_down_multiplier = slow_down
	slow_down()

func _on_area_entered(area: Area2D) -> void:
	pass
