class_name Equipment
extends Resource

## The scene to be spawned.
@export var scene: PackedScene
@export var name: String

## To use in unlocking new weapons later in game
@export var value: int

func use() -> void:
	pass
