class_name SpawnEntry
extends Resource

## The scene to be spawned.
@export var scene: PackedScene

## The weight (weight of getting chosen randomly) of the entry.
## Higher weight results in higher probability of getting chosen.
@export var weight: float = 1.0
