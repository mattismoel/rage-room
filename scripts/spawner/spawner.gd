class_name SpawnerComponent
extends Node2D

signal spawned(entry: SpawnEntry, insect: Insect)

@export var _container: Node2D
@export var _entry_selector: SpawnEntrySelector

@export_category("Debug")
@export var _debug_spawn: bool = false

## Spawns the input packed scene into the input container node, at the given 
## input position.
func spawn(pos: Vector2 = Vector2.ZERO) -> void:
	var entry :=  _entry_selector.get_entry()
	var insect: Insect = entry.scene.instantiate()

	if _container == null:
		add_child(insect)
	else:
		_container.add_child(insect)

	if pos == Vector2.ZERO:
		insect.global_position = _container.global_position
	else:
		insect.global_position = pos

	spawned.emit(entry, insect)

	if _debug_spawn:
		print("Spawned insect %s" % insect.name)

	InsectManager.add([insect])
