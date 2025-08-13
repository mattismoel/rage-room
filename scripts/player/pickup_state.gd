class_name PickUpState
extends State

var inventory: InventoryComponent

@export var equipment_state: EquipmentState
@export var idle_state: IdleState
@export var _animation_player: AnimationPlayer

func enter() -> void:
	super()
	inventory.entry_equipped.connect(_on_equipment_picked_up)
	inventory.mouse_exited.connect(_on_mouse_leave_inventory)
	_animation_player.play("pick_up")
	visible = true
	
func exit() -> void:
	super()
	inventory.entry_equipped.disconnect(_on_equipment_picked_up)
	inventory.mouse_exited.disconnect(_on_mouse_leave_inventory)
	visible = false
	
func _on_mouse_leave_inventory() -> void:
	## Switch to idle state
	changed_state.emit(idle_state)

func _on_equipment_picked_up(equipment_entry: EquipmentEntry) -> void:
	equipment_state.set_equipment(equipment_entry)
	changed_state.emit(equipment_state)
