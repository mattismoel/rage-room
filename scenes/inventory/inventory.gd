class_name Inventory
extends Node2D

@export var inventory_area: CollisionShape2D
@onready var inventory_rect: Rect2 = inventory_area.get_shape().get_rect()

var inventory_slots: Array[InventorySlot] = []

var _mouse_inside_inventory: bool
signal mouse_entered
signal mouse_left

func _ready() -> void:
	InventoryManager.inventory_changed.connect(_on_inventory_changed)
	
	## Append all inventory slots to array
	for child in get_children():
		if child is InventorySlot:
			inventory_slots.append(child)
	print(inventory_slots.size())
	## Calculates rectangle for detecting when the mouse is in the inventory
	inventory_rect.position += inventory_area.global_position

## THIS IS ONLY FOR DEBUGGING PURPOSES
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_E:
			print("add test_entry")
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

func _process(delta: float) -> void:
	## Detetct if the mouse is entering or leaving the inventory
	var mouse_pos := get_global_mouse_position()
	if inventory_rect.has_point(mouse_pos) and not _mouse_inside_inventory:
		mouse_entered.emit()
		_mouse_inside_inventory = true
	elif not inventory_rect.has_point(mouse_pos) and _mouse_inside_inventory:
		mouse_left.emit()
		_mouse_inside_inventory = false
