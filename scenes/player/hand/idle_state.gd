class_name IdleState
extends State

@export var _pick_up_state: PickUpState
@export var _smack_state: SmackState
@export var _animation_player: AnimationPlayer

var _inventory: Control

func enter() -> void:
	super()
	visible = true
	_animation_player.play("idle")

func initialize(inventory: InventoryUI) -> void:
	_inventory = inventory
	inventory.entry_entered.connect(_on_entry_entered)

func input(event) -> void:
	if event.is_action_pressed("interact"):
		changed_state.emit(_smack_state)

func exit() -> void:
	super()
	visible = false

func _on_entry_entered(_entry: EquipmentEntry) -> void:
	changed_state.emit(_pick_up_state)
