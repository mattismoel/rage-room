extends State

@export var equipment_state: EquipmentState

func pick_up_equipment(equipment_entry: EquipmentEntry) -> void:
	equipment_state.set_equipment(equipment_entry)
	change_state.emit(equipment_state)
