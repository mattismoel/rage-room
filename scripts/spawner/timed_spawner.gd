class_name TimedSpawner
extends Node

@export var _spawn_timer: SpawnTimer
@export var _spawner_component: SpawnerComponent

func _ready() -> void:
	if _spawner_component == null:
		push_error("SpawnComponent on TimedSpawner must be set!")
		return

	_spawn_timer.timeout.connect(_on_timeout)

func _on_timeout() -> void:
	_spawner_component.spawn()
	pass
