extends Node

var inventory: Array[EquipmentEntry] = []
var equipped_entry: EquipmentEntry

signal inventory_changed
signal entry_equipped(entry: EquipmentEntry)

func eqiup(new_entry: EquipmentEntry) -> void:
	print("picked up ", new_entry.name)
	## Put the currently equipped entry back in the inventory
	add_entry(equipped_entry)
	
	## Remove the entry being picked up from the inventory
	remove_entry(new_entry)
	equipped_entry = new_entry
	
	entry_equipped.emit(new_entry)

func unequip() -> void:
	#print("unequipped ", equipped_entry.name)
	## Put the currently equipped entry back in the inventory
	add_entry(equipped_entry)
	equipped_entry = null

func add_entry(entry: EquipmentEntry) -> void:
	## Add entry (if it is not null) to inventory
	if entry != null: inventory.append(entry)
	
	## Signal that inventory has been changed
	inventory_changed.emit()

func remove_entry(entry: EquipmentEntry) -> void:
	## Remove entry from inventory
	inventory.erase(entry)
	
	## Signal that inventory has been changed
	inventory_changed.emit()
