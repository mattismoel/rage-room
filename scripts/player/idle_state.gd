class_name IdleState
extends State

@export var selection_area: CollisionObject2D
@export var pick_up_state: PickUpState
@export var smack_state: SmackState

func enter() -> void:
	super()
	visible = true
		
func input(event) -> void:
	if event.is_action_pressed("interact"):
		## Switch to smack state
		change_state.emit(smack_state)

func exit() -> void:
	super()
	visible = false
