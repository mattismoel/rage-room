extends Node

var inventory: Array[EquipmentEntry] = []
var equipped_entry: EquipmentEntry

signal inventory_changed
signal entry_equipped(entry: EquipmentEntry)
signal entry_unequipped

## Takes the entry being equipped as argument and returns what it replaces
func eqiup(new_entry: EquipmentEntry) -> EquipmentEntry:
	var replaced_entry := equipped_entry
	equipped_entry = new_entry
	
	## Put the entry that is being replaced back in the inventory
	if replaced_entry != null: inventory.append(replaced_entry)
	entry_unequipped.emit()
	
	## Remove the entry that is being picked up from the inventory
	inventory.erase(new_entry)
	
	entry_equipped.emit(new_entry)
	return replaced_entry

func unequip() -> EquipmentEntry:
	var replaced_entry := equipped_entry
	
	## Put the currently equipped entry back in the inventory
	if replaced_entry != null: inventory.append(replaced_entry)
	equipped_entry = null
	
	entry_unequipped.emit()
	return replaced_entry

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
