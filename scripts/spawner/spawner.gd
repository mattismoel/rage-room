class_name SpawnerComponent
extends Node2D

signal spawned(entry: SpawnEntry, node: Node)

@export var _container: Node2D
@export var _entry_selector: SpawnEntrySelector

@export_category("Debug")
@export var _debug_spawn: bool = false

## Spawns the input packed scene into the input container node, at the given 
## input position.
func spawn(pos: Vector2 = Vector2.ZERO) -> void:
	var entry :=  _entry_selector.get_entry()
	var instance: Node2D = entry.scene.instantiate()

	if _container == null:
		add_child(instance)
	else:
		_container.add_child(instance)

	if pos == Vector2.ZERO:
		instance.global_position = _container.global_position
	else:
		instance.global_position = pos

	spawned.emit(entry, instance)

	if _debug_spawn:
		print("Spawned %s" % instance.name)

	InsectManager.add([instance])
