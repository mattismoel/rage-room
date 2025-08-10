## Randomly selects one of the spawn entries.
class_name RandomSpawnEntrySelector
extends SpawnEntrySelector

var _entries: Array[SpawnEntry] = []

func get_entry() -> SpawnEntry:
	return _entries.pick_random()
