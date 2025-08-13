class_name InventorySlot
extends Button

@export var initial_equipment: EquipmentEntry
var stored_equipment: EquipmentEntry

signal equipment_change(slot: InventorySlot)
signal buy_equipment_attempt(entry: EquipmentEntry)

func _ready() -> void:
	set_entry(initial_equipment)
	pressed.connect(_on_pressed)

func set_entry(entry: EquipmentEntry):
	if entry == null: return clear()
	stored_equipment = entry

	## Set slot to display the stored equipment entry
	if stored_equipment.unlocked:
		text = entry.name
	else:
		text = "Cost: %d" % stored_equipment.cost

func clear():
	text = ""
	stored_equipment = null

func _on_pressed():
	equipment_change.emit(self)
