class_name InventorySlot
extends Button

@export var initial_equipment: EquipmentEntry
var stored_equipment: EquipmentEntry

func _ready() -> void:
	set_entry(initial_equipment)
	InventoryManager.add_entry(initial_equipment)
	pressed.connect(_on_pressed)

func set_entry(entry: EquipmentEntry):
	if entry == null: return clear()
	
	## Set slot to display the stored equipment entry
	text = entry.name  # Or set an icon, etc.
	stored_equipment = entry

func clear():
	text = ""
	stored_equipment = null

func _on_pressed():
	var new_slot_entry: EquipmentEntry
	
	## If slot is not empty, equip what is already there. Else just unequip.
	if stored_equipment != null: new_slot_entry = InventoryManager.eqiup(stored_equipment)
	else: new_slot_entry = InventoryManager.unequip()
	
	set_entry(new_slot_entry)
