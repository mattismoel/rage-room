class_name IdleState
extends State

var inventory: Inventory

@export var selection_area: CollisionObject2D
@export var pick_up_state: PickUpState
@export var smack_state: SmackState
@export var _animation_player: AnimationPlayer

func enter() -> void:
	super()
	visible = true
	_animation_player.play("idle")
	
	## Fix for weird reference bug
	if inventory != null: initialize(inventory)

func initialize(ref_inventory) -> void:
	inventory = ref_inventory
	inventory.mouse_entered.connect(_on_mouse_enter_inventory)

func _on_mouse_enter_inventory() -> void:
	changed_state.emit(pick_up_state)

func input(event) -> void:
	if event.is_action_pressed("interact"):
		## Switch to smack state
		changed_state.emit(smack_state)

func exit() -> void:
	super()
	inventory.mouse_entered.disconnect(_on_mouse_enter_inventory)
	visible = false
