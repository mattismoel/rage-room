class_name Hand
extends Node2D

@export var struggle_component: StruggleComponent
@export var _equipment_container: Node2D

@export var initial_equipment: EquipmentEntry

func _ready() -> void:
	set_equipment(initial_equipment)

func set_equipment(entry: EquipmentEntry) -> void:
	## Queue free any previous equipment.
	for child in _equipment_container.get_children():
		child.queue_free()

	var equipment := entry.scene.instantiate() as Equipment
	_equipment_container.add_child(equipment)
	pass
