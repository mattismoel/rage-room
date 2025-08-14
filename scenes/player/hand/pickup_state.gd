class_name PickUpState
extends State

@export var _equipment_state: EquipmentState
@export var _idle_state: IdleState
@export var _animation_player: AnimationPlayer

var _inventory: InventoryUI
var _inventory_component: InventoryComponent

func enter() -> void:
	super()
	_animation_player.play("pick_up")
	visible = true
	
func exit() -> void:
	super()
	visible = false

func initialise(inventory_component: InventoryComponent, inventory: Control) -> void:
	_inventory_component = inventory_component
	_inventory = inventory

	_inventory_component.equipped_entry.connect(_on_equipped)
	_inventory.entry_exited.connect(_on_entry_exited)
	
func _on_entry_exited(_entry: EquipmentEntry) -> void:
	if _inventory_component.current_equipment() != null:
		changed_state.emit(_equipment_state)
		return

	changed_state.emit(_idle_state)

func _on_equipped(_entry: EquipmentEntry) -> void:
	changed_state.emit(_equipment_state)
