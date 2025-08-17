class_name Hand
extends Node2D

@export var _equipment_container: Node2D

var _current_equipment: Equipment

func set_equipment(entry: EquipmentEntry) -> void:
	## Queue free any previous equipment.
	for child in _equipment_container.get_children():
		child.queue_free()

	var equipment := entry.scene.instantiate() as Equipment
	_equipment_container.add_child(equipment)
	_current_equipment = equipment

func enable_equipment() -> void:
	if !_current_equipment: return
	_current_equipment.enable()

func disable_equipment() -> void:
	if !_current_equipment: return
	_current_equipment.disable()
