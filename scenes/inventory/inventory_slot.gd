class_name InventorySlot
extends Button

@export var initial_equipment: EquipmentEntry
var _stored_equipment: EquipmentEntry

func _ready() -> void:
	set_entry(initial_equipment)
	pressed.connect(_on_pressed)

func set_entry(entry: EquipmentEntry):
	if entry == null:
		clear()
		return
	print("place ", entry.name)
	
	## Set slot to display the stored equipment entry
	_stored_equipment = entry
	text = entry.name  # Or set an icon, etc.

func clear():
	_stored_equipment = null
	text = ""

func _on_pressed():
	#if InventoryManager.equipped_entry == null:
		#clear()
	#else:
		#set_entry(InventoryManager.equipped_entry)

	## If slot is not empty, equip what is already there. Else just unequip.
	if _stored_equipment != null:
		print("equip")
		var before := InventoryManager.equipped_entry
		InventoryManager.eqiup(_stored_equipment)
		if before == null:
			clear()
		else:
			set_entry(before)

	else:
		print("unequip")
		set_entry(InventoryManager.equipped_entry)
		InventoryManager.unequip()
