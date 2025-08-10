extends State

@export var equipment_state: EquipmentState

func pick_up_equipment(equipment: Equipment) -> void:
	equipment_state.set_equipment(equipment)
	change_state.emit(equipment_state)
