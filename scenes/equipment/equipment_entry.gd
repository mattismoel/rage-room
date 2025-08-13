class_name EquipmentEntry
extends Resource

@export var name: String

## The scene to be spawned
@export var scene: PackedScene

## Cost to unlock the equipment
@export var cost: int
var unlocked: bool = false
