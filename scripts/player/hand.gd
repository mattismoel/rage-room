extends Node2D

@export var inventory: Inventory

@export var state_machine: StateMachine
@export var equipment_state: EquipmentState
@export var idle_state: IdleState
@export var pick_up_state: PickUpState

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	
func _input(event: InputEvent) -> void:
	handle_equipment_change(event)

func handle_equipment_change(event: InputEvent) -> void:
	## This is only meant for debugging/as an alternative to picking the equipment manually
	if event is InputEventKey and event.pressed:
		## If keycode is 0, go to idle state (no equipment)
		if event.keycode == KEY_1:
			state_machine.change_state(idle_state)
			
		## Check if keypress is a number between 0 and 9
		if event.keycode >= KEY_2 and event.keycode <= KEY_9:
			var digit_pressed: int = -KEY_2 + event.keycode
			
			## Switch to equipment state after choosing equipment
			equipment_state.set_equipment_from_index(digit_pressed)
			state_machine.change_state(equipment_state)
