## Selects an entry based on the weight of the spawn entry.
class_name WeightedSpawnEntrySelector
extends SpawnEntrySelector

@export var _entries: Array[SpawnEntry] = []

func _ready() -> void:
	if _entries.size() <= 0:
		push_error("This weighted spawn entry selector has no entries!")

func get_entry() -> SpawnEntry:
	var entry := _pick_weighted_entry()
	return entry

## Picks random entry from the spawners entry.
func _pick_weighted_entry() -> SpawnEntry:
	var sum := 0.0

	for entry in _entries:
		sum += entry.weight

	var rnd := randf_range(0, sum)

	for entry in _entries:
		if rnd < entry.weight:
			return entry
		rnd -= entry.weight

	return null
