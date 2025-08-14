class_name InventoryUI
extends Control

signal entry_entered(entry: EquipmentEntry)
signal entry_exited(entry: EquipmentEntry)
signal entry_selected(entry: EquipmentEntry)

@export var _currency_component: CurrencyComponent
@export var _inventory_component: InventoryComponent
@export var _slot_container: Control

var _slots: Array[InventorySlot] = []

func _ready() -> void:
	_inventory_component.equipped_entry.connect(_on_equip)

	for child in _slot_container.get_children(true):
		if child is not InventorySlot: continue
		_slots.append(child)

	var initial_equipment := _inventory_component.get_equipment_entries()

	assert(_slots.size() >= initial_equipment.size(), "There are not enough inventory slots for the given InventoryComponent.")

	for i in range(initial_equipment.size()):
		var entry := initial_equipment[i]

		_slots[i].initialise(_inventory_component)
		_slots[i].set_entry(entry)

		_slots[i].bought.connect(func(): _on_entry_bought(entry))
		_slots[i].mouse_entered.connect(func(): _on_entry_entered(entry))
		_slots[i].mouse_exited.connect(func(): _on_entry_exited(entry))
		_slots[i].selected.connect(func(): _on_entry_selected(entry))

func _on_equip(entry: EquipmentEntry) -> void:
	for slot in _slots:
		if slot.get_entry() != entry: continue

		## The equipped entry is the current one
		## ...

func _on_entry_bought(entry: EquipmentEntry) -> void:
	var bought := _currency_component.attempt_purchase(entry.cost)

	if !bought: return

	_inventory_component.unlock_entry(entry)
	pass

func _on_entry_entered(entry: EquipmentEntry) -> void:
	entry_entered.emit(entry)
	pass

func _on_entry_exited(entry: EquipmentEntry) -> void:
	entry_exited.emit(entry)
	pass

func _on_entry_selected(entry: EquipmentEntry) -> void:
	if !entry.is_unlocked: return

	_inventory_component.equip(entry)
	entry_selected.emit(entry)

# func allocate_to_vacant_slots() -> void:
# 	## Allocate missing inventory equipment entries to vacant slots
# 	## There is a lot of for-loops and if-statements here. Can it be improved? likely..
# 	for i in range(inventory.size()):
# 		## Check if this entry is already equipped
# 		var homeless := false
# 		if inventory[i] != _current_equipment:
# 			homeless = true
#
# 		## Check if this entry has been assigned a slot
# 		for slot in slots:
# 			if slot.stored_equipment == inventory[i]:
# 				homeless = false
# 				break
#
# 		if not homeless: continue
# 		## Look for vacant slots and assign entry to one if found
# 		for slot in slots:
# 			if slot.stored_equipment == null:
# 				slot.set_entry(inventory[i])
# 				break

