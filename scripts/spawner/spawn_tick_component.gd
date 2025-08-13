class_name SpawnTimer
extends Timer

## The initial spawn rate (amount of spawns per second).
@export var _spawn_rate: float = 0.25

@export var _max_spawn_rate: float = 10.0

## The amount the spawn rate should increase by for each spawn.
@export var _spawn_rate_increase_per_spawn: float = 0.0

func _ready() -> void:
	timeout.connect(_on_timeout)
	wait_time = 1.0 / _spawn_rate

func _on_timeout() -> void:
	_spawn_rate += _spawn_rate_increase_per_spawn
	_spawn_rate = min(0.0, _max_spawn_rate)
	pass

