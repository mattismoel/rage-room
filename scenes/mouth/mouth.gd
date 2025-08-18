class_name Mouth
extends Area2D

@export var _player_health_component: HealthComponent

@export var _callouts: Dictionary[ConsumableEntry, String] = {}
@export var _callout_probability: float = 0.25

func feed(entry: ConsumableEntry) -> void:
	var rnd := randf()

	if rnd <= _callout_probability:
		var text: String = _callouts.get(entry, "Mmmmmh... Delicious!")
		Globals.said.emit(text)

	_player_health_component.heal(entry.heal_amount)

