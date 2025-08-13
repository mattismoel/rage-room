class_name InventoryComponent
extends Control

@export var currency_component: CurrencyComponent

var inventory: Array[EquipmentEntry] = []
var slots: Array[InventorySlot] = []
var equipped_entry: EquipmentEntry

signal entry_equipped(entry: EquipmentEntry)
signal entry_unequipped

func _ready() -> void:	
	## Append all inventory slots to array
	for child in get_children():
		if child is InventorySlot:
			slots.append(child)
			inventory.append(child.initial_equipment)
			child.equipment_change.connect(_on_slot_clicked)

func _on_slot_clicked(slot: InventorySlot) -> void:
	var new_slot_entry: EquipmentEntry
	
	## If slot is not empty, equip what is already there. Else just unequip.
	if 	slot.stored_equipment != null:
		
		## Purchase the equipment if it is not unlocked
		if not slot.stored_equipment.unlocked:
			var cost := slot.stored_equipment.cost
			var purchased := currency_component.attempt_purchase(cost)
			
			slot.stored_equipment.unlocked = true if purchased else false
			if not purchased: return
			
		new_slot_entry = eqiup(slot.stored_equipment)
	else: new_slot_entry = unequip()
	
	slot.set_entry(new_slot_entry)

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

func has_mouse_inside() -> bool:
	var mouse_pos = get_viewport().get_mouse_position()
	return 	get_global_rect().has_point(mouse_pos)

## THIS SECTION IS ONLY FOR DEBUGGING PURPOSES (AND CHEATERS)
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_E:
			print("ADDED test_entry")
			const test_entry = preload("res://scenes/equipment/entries/test_equipment_entry.tres");
			inventory.append(test_entry)
			allocate_to_vacant_slots()

func allocate_to_vacant_slots() -> void:
	## Allocate missing inventory equipment entries to vacant slots
	## There is a lot of for-loops and if-statements here. Can it be improved? likely..
	for i in range(inventory.size()):
		## Check if this entry is already equipped
		var homeless := false
		if inventory[i] != equipped_entry:
			homeless = true
		
		## Check if this entry has been assigned a slot
		for slot in slots:
			if slot.stored_equipment == inventory[i]:
				homeless = false
				break
			
		if not homeless: continue
		## Look for vacant slots and assign entry to one if found
		for slot in slots:
			if slot.stored_equipment == null:
				slot.set_entry(inventory[i])
				break
