class_name TimedSpawner
extends Node2D

@export_group("References")
@export var _spawn_timer: SpawnTimer
@export var _spawner_component: SpawnerComponent

func _ready() -> void:
	assert(_spawner_component != null, "SpawnComponent on TimedSpawner must be set!")
	_spawn_timer.timeout.connect(_on_timeout)

func _on_timeout() -> void:
	_spawner_component.spawn()
	pass
