extends Node2D

@export var _max_vertical_arm_extension: float = 100
@export var _struggle_extension: float = 70
@onready var _logistic_constant: float = -log((_max_vertical_arm_extension/\
_struggle_extension)-1)/(_struggle_extension-_max_vertical_arm_extension/2)

@export var _inventory_component: InventoryComponent
@export var _game_ui: GameUI

@export_group("States references")
@export var idle_state: IdleState
@export var smack_state: SmackState
@export var pick_up_state: PickUpState
@export var equipment_state: EquipmentState

func _ready() -> void:
	assert(!is_nan(_logistic_constant), "Invalid values for arm extension")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	idle_state.initialize(_game_ui) # Fix for weird missing reference bug
	pick_up_state.initialise(_inventory_component, _game_ui)
	equipment_state.initialise(_inventory_component, _game_ui)
	smack_state.initialise(_game_ui)

## Converts regular coordinates to godot coordinates and vice versa
func _coords_convert(in_cords: float) -> float:
	return get_window().content_scale_size.y - in_cords

func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var y_pos = _coords_convert(mouse_pos.y)
	
	## Arm is limited by a logistic function if extended past the struggle bound
	if _coords_convert(mouse_pos.y) > _struggle_extension:		
		var variable = _coords_convert(mouse_pos.y)
		y_pos = _max_vertical_arm_extension/(1+exp(-_logistic_constant\
		*(variable-_max_vertical_arm_extension/2)))
		
	global_position = Vector2(mouse_pos.x, _coords_convert(y_pos))
	
#func _input(event: InputEvent) -> void:
	#handle_equipment_change(event)

#func handle_equipment_change(event: InputEvent) -> void:
	### This is only meant for debugging/as an alternative to picking the equipment manually
	#if event is InputEventKey and event.pressed:
		### If keycode is 0, go to idle state (no equipment)
		#if event.keycode == KEY_1:
			#state_machine.change_state(idle_state)
			#
		### Check if keypress is a number between 0 and 9
		#if event.keycode >= KEY_2 and event.keycode <= KEY_9:
			#var digit_pressed: int = -KEY_2 + event.keycode
			#
			### Switch to equipment state after choosing equipment
			#equipment_state.set_equipment_from_index(digit_pressed)
			#state_machine.change_state(equipment_state)
