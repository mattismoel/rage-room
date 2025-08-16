class_name Insect
extends Node2D

const BLOOD_SPLAT_SCENE := preload("uid://byunc756cgkpf")

## Emitted whenever the insect takes a bite. It contains the amount of _damage_per_bite 
## dealt.
signal took_bite(damage: float)

## Emitted whenever the insect is killed. It containes a reference to itself.
signal killed(insect: Insect)

const BASE_SLOW_DOWN_TIME: float = 12.0

## The amount of damage per bite.
@export var damage: float = 1.0

@export var _damage_per_bite: float = 1.0
@export var _hitbox: Area2D
@export var _bite_timer: RateTimer

## How resistant the insect is to _damage_per_bite.
##
## Values range from [0.0, 1.0].
@export_range(0.0, 1.0) var _resistance: float = 0.0

@export var _health_component: HealthComponent
@export var _target_zone: TargetZone

var _current_target: Target

func _ready() -> void:
	InsectManager.add([self])

	## We need to wait two physics frames for some reason...
	await get_tree().physics_frame
	await get_tree().physics_frame

	_hitbox.area_entered.connect(_on_area_entered)
	_health_component.health_depleted.connect(_on_health_depleted)
	_bite_timer.timeout.connect(_on_bite_timer_timeout)

	## If the insect has no target zone, it is considered target-less, and we do
	## not wish to target anything.
	if _target_zone == null:
		return

	var t := _target_zone.find_target()

	target(t)

## Targets the input target t. 
## This must be implemented by the descendant.
func target(_t: Target) -> void:
	assert(false, "The 'target()' method must be implemented by descendant!")
	pass

## This function must be implemented in the specific insect to slow down properly
func slow_down(effectiveness: float) -> void:
	assert(false, "The 'slow_down()' method must be implemented by descendant!")
	pass

func splat() -> void:
	var blood_splat: Node2D = BLOOD_SPLAT_SCENE.instantiate()
	get_parent().add_child(blood_splat)
	blood_splat.global_position = global_position
	queue_free()

func kill() -> void:
	killed.emit(self)

func take_damage(amount: float) -> void:
	var damage_taken := _calculate_damage(amount, _resistance)
	_health_component.take_damage(damage_taken)
	pass

func _calculate_damage(amount: float, resistance: float) -> float:
	return amount - resistance * amount

func _on_health_depleted() -> void:
	kill()

func _on_area_entered(area: Area2D) -> void:
	if area is not Target: return
	_current_target = area
	_bite_timer.start()

func _on_bite_timer_timeout() -> void:
	assert(_current_target != null, "The insect attempted to bit a null target!")
	took_bite.emit(_damage_per_bite)
