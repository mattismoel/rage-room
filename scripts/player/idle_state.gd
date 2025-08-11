class_name IdleState
extends State

@export var selection_area: CollisionObject2D
@export var pick_up_state: PickUpState
@export var smack_state: SmackState

@export var inventory: Inventory
@onready var inventory_area: CollisionShape2D = inventory.selectable_area
@onready var inventory_rect: Rect2 = inventory_area.get_shape().get_rect()

func enter() -> void:
	super()
	visible = true
	## Calculates rectangle for detecting when the mouse is in the inventory
	inventory_rect.position = Vector2(\
		inventory_area.global_position.x-inventory_rect.size.x/2,\
		inventory_area.global_position.y-inventory_rect.size.y/2)
		
func input(event) -> void:
	if event.is_action_pressed("interact"):
		print("Mouse pressed at: ", event.position)
	
		## Switch to smack state
		change_state.emit(smack_state)

func process(delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	if inventory_rect.has_point(mouse_pos):
		## Switches to pickup state if mouse is hovering over the inventory
		change_state.emit(pick_up_state)

func exit() -> void:
	super()
	visible = false
