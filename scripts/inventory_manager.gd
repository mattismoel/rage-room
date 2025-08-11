extends Node

var inventory: Array[EquipmentEntry] = []
signal inventory_changed

func add_equipment_to_inventory(entry: EquipmentEntry) -> void:
	inventory.append(entry)
	inventory_changed.emit()
	#equip_item(entry)

func remove_equipment_from_inventory(entry: EquipmentEntry) -> void:
	inventory.erase(entry)
	inventory_changed.emit()
