class_name PickUpState
extends State

@export var equipment_state: EquipmentState
@export var idle_state: IdleState

func enter() -> void:
	super()
	InventoryManager.entry_equipped.connect(_on_equipment_picked_up)
	visible = true
	
func exit() -> void:
	super()
	InventoryManager.entry_equipped.disconnect(_on_equipment_picked_up)
	visible = false

func _on_equipment_picked_up(equipment_entry: EquipmentEntry) -> void:
	equipment_state.set_equipment(equipment_entry)
	change_state.emit(equipment_state)
