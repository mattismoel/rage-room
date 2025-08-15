class_name InventoryComponent
extends Node

@export var _equipment: Array[EquipmentEntry] = []

## Emitted whenever an equipment has been equipped.
signal equipped_entry(entry: EquipmentEntry)

## Emitted whenever an equipment has been unequipped.
signal unequipped_entry(entry: EquipmentEntry)

## Emitted whenever no equipment is equipped.
signal selection_cleared

## Emitted whenever a new equipment has been unlocked.
signal unlocked_entry(entry: EquipmentEntry)

var _current_equipment: EquipmentEntry

## Takes the entry being equipped as argument and returns what it replaces
func equip(new_entry: EquipmentEntry) -> EquipmentEntry:
	var replaced_entry := _current_equipment
	_current_equipment = new_entry
	
	## Put the entry that is being replaced back in the inventory
	if replaced_entry != null: 
		_equipment.append(replaced_entry)
		unequipped_entry.emit(replaced_entry)
	
	## Remove the entry that is being picked up from the inventory
	_equipment.erase(new_entry)
	
	equipped_entry.emit(new_entry)
	return replaced_entry

## Unequips the currently selected entry, returning what it unequips.
func unequip() -> EquipmentEntry:
	var replaced_entry := _current_equipment
	
	## Put the currently equipped entry back in the inventory
	if replaced_entry != null: _equipment.append(replaced_entry)
	_current_equipment = null
	
	unequipped_entry.emit(replaced_entry)
	return replaced_entry

## Unlocks the input entry and equips it
func unlock_entry(entry: EquipmentEntry, should_equip: bool = true):
	entry.unlock()
	unlocked_entry.emit(entry)
	equip(entry)

#func deselect_all() -> void:
	#if _current_equipment != null:
		#unequip()
#
	#selection_cleared.emit()

func get_equipment_entries() -> Array[EquipmentEntry]:
	return _equipment

func current_equipment() -> EquipmentEntry:
	return _current_equipment
