class_name PickUpState
extends State

@export var selection_area: CollisionObject2D
@export var equipment_state: EquipmentState
@export var idle_state: IdleState

func enter() -> void:
	super()
	selection_area.area_exited.connect(_on_area_exited)
	visible = true
	
func exit() -> void:
	super()
	selection_area.area_exited.disconnect(_on_area_exited)
	visible = false

func input(event) -> void:
	if event.is_action_pressed("interact"):
		print("Mouse pressed at: ", event.position)
		var overlapping_areas: Array[Area2D] = selection_area.get_overlapping_areas()
		for area in overlapping_areas:
			if area.get_parent() is Equipment:
				print(area.get_parent().name)

func pick_up_equipment(equipment_entry: EquipmentEntry) -> void:
	equipment_state.set_equipment(equipment_entry)
	change_state.emit(equipment_state)

func _on_area_exited(area: Area2D) -> void:
	if area.get_parent() is Inventory:
		## Switch to idle state
		change_state.emit(idle_state)
