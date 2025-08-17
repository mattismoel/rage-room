class_name InventoryUI
extends Control

signal entry_entered(entry: EquipmentEntry)
signal entry_exited(entry: EquipmentEntry)
signal entry_selected(entry: EquipmentEntry)
signal entry_pressed(entry: EquipmentEntry)
signal entry_bought(entry: EquipmentEntry)

@export var _inventory_slot_scene: PackedScene
@export var _slot_container: Control

var _slots: Array[InventorySlot] = []

func set_equipment_entries(entries: Array[EquipmentEntry]) -> void:
	for entry in entries:
		var slot: InventorySlot = _inventory_slot_scene.instantiate()

		slot.set_entry(entry)
		slot.disable()

		slot.bought.connect(func(): entry_bought.emit(entry))
		slot.mouse_entered.connect(func(): entry_entered.emit(entry))
		slot.mouse_exited.connect(func(): entry_exited.emit(entry))
		slot.pressed.connect(func(): entry_pressed.emit(entry))
		
		## Remove the buy button etc. if the entry is already unlocked
		if entry.is_unlocked:
			slot.unlock()
			slot.enable()
		
		_slot_container.add_child(slot)
		_slots.append(slot)

func unlock_slot(entry: EquipmentEntry) -> void:
	for slot in _slots:
		if slot.entry != entry: continue
		slot.unlock()
	vacate_slot(entry)

func vacate_slot(entry: EquipmentEntry) -> void:
	for slot in _slots:
		slot.disable()
		if slot.entry != entry: continue
		slot.enable()
		
		## The item slot will stay out if this line is uncommented
		#slot.animation_disabled = true
		slot.clear()

func populate_slot(entry: EquipmentEntry) -> void:
	for slot in _slots:
		#slot.enable()
		if slot.entry != entry: continue
		slot.set_entry(entry)

func enable_affordable_slots(new_balance: float) -> void:
	for slot in _slots:
		if new_balance >= slot.entry.cost:
			slot.enable()
