class_name EquipmentEntry
extends Resource

@export var name: String

## The scene to be spawned
@export var scene: PackedScene

## Cost to unlock the equipment
@export var cost: int

## Whether or not the equipment has been is_unlocked.
@export var is_unlocked: bool = false

func unlock() -> void:
	is_unlocked = true
	pass
