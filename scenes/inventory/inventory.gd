class_name InventoryUI
extends Control

signal entry_entered(entry: EquipmentEntry)
signal entry_exited(entry: EquipmentEntry)
signal entry_selected(entry: EquipmentEntry)
signal entry_bought(entry: EquipmentEntry)

@export var _inventory_slot_scene: PackedScene
@export var _slot_container: Control

var _slots: Array[InventorySlot] = []

func set_equipment_entries(entries: Array[EquipmentEntry]) -> void:
	for entry in entries:
		var slot: InventorySlot = _inventory_slot_scene.instantiate()
		_slot_container.add_child(slot)

		slot.set_entry(entry)

		slot.bought.connect(func(): entry_bought.emit(entry))
		slot.mouse_entered.connect(func(): entry_entered.emit(entry))
		slot.mouse_exited.connect(func(): entry_exited.emit(entry))
		slot.selected.connect(func(): entry_selected.emit(entry))

func select_entry(new_entry: EquipmentEntry) -> void:
	if !new_entry.is_unlocked: return

	for slot in _slots:
		if slot.entry != new_entry: continue
		slot.set_entry(new_entry)
			
	entry_selected.emit(new_entry)
