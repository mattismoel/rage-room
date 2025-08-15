class_name Mouth
extends Area2D

@export var _player_health_component: HealthComponent

func feed(entry: ConsumableEntry) -> void:
	_player_health_component.heal(entry.heal_amount)
	pass
