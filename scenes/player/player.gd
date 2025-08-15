extends Node

@export var _health_component: HealthComponent
@export var _hunger_per_second: float = 0.1

func _process(delta: float) -> void:
	_health_component.take_damage(_hunger_per_second * delta)
