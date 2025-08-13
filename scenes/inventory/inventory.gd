class_name Inventory
extends Control

var inventory_slots: Array[InventorySlot] = []

func _ready() -> void:
	InventoryManager.inventory_changed.connect(_on_inventory_changed)
	
	## Append all inventory slots to array
	for child in get_children():
		if child is InventorySlot:
			inventory_slots.append(child)

## THIS IS ONLY FOR DEBUGGING PURPOSES
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_E:
			print("ADDED test_entry")
			const test_entry = preload("res://scenes/equipment/entries/test_equipment_entry.tres");
			InventoryManager.add_entry(test_entry)

func _on_inventory_changed() -> void:
	## Allocate missing inventory equipment entries to vacant slots
	## There is a lot of for-loops and if-statements here. Can it be improved? likely..
	var entries := InventoryManager.inventory
	for i in range(entries.size()):
		## Check if this entry is already equipped
		var homeless := false
		if entries[i] != InventoryManager.equipped_entry:
			homeless = true 
		
		## Check if this entry has been assigned a slot
		for slot in inventory_slots:
			if slot.stored_equipment == entries[i]:
				homeless = false
				break
			
		if not homeless: continue
		## Look for vacant slots and assign entry to one if found
		for slot in inventory_slots:
			if slot.stored_equipment == null:
				slot.set_entry(entries[i])
				break
