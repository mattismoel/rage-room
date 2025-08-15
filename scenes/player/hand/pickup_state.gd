class_name PickUpState
extends State

@export var _equipment_state: EquipmentState
@export var _idle_state: IdleState
@export var _animation_player: AnimationPlayer

var _inventory_component: InventoryComponent
var _game_ui: GameUI

func enter() -> void:
	super()
	_animation_player.play("pick_up")
	visible = true
	
func exit() -> void:
	super()
	visible = false

func initialise(inventory_component: InventoryComponent, game_ui: GameUI) -> void:
	_inventory_component = inventory_component
	# _inventory = inventory
	_game_ui = game_ui

	_inventory_component.equipped_entry.connect(_on_equipped)
	_game_ui.inventory.entry_exited.connect(_on_entry_exited)
	
func _on_entry_exited(_entry: EquipmentEntry) -> void:
	if _inventory_component.current_equipment() == null:
		changed_state.emit(_idle_state)
		return

func equip(entry: EquipmentEntry) -> void:
	pass

func _on_equipped(_entry: EquipmentEntry) -> void:
	changed_state.emit(_equipment_state)
