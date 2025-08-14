class_name InventoryComponent
extends Node

# @export var currency_component: CurrencyComponent

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

# func _on_slot_clicked(slot: InventorySlot) -> void:
# 	var new_slot_entry: EquipmentEntry
#
# 	## If slot is not empty, equip what is already there. Else just unequip.
# 	if 	slot.stored_equipment != null:
#
# 		## Purchase the equipment if it is not unlocked
# 		# if not slot.stored_equipment.unlocked:
# 			# var cost := slot.stored_equipment.cost
# 			# var purchased := currency_component.attempt_purchase(cost)
#
# 			# slot.stored_equipment.unlocked = true if purchased else false
# 			# if not purchased: return
#
# 		new_slot_entry = equip(slot.stored_equipment)
# 	else: new_slot_entry = unequip()
#
# 	slot.set_entry(new_slot_entry)


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
	
	unequipped_entry.emit()
	return replaced_entry

## Unlocks the input entry and equips it.
func unlock_entry(entry: EquipmentEntry, should_equip: bool = true) -> void:
	entry.unlock()
	unlocked_entry.emit(entry)
	equip(entry)

func deselect_all() -> void:
	if _current_equipment != null:
		unequip()

	selection_cleared.emit()

func get_equipment_entries() -> Array[EquipmentEntry]:
	return _equipment


func current_equipment() -> EquipmentEntry:
	return _current_equipment
