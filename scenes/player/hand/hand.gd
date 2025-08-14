extends Node2D

@export var _max_vertical_extension: float = 100
@export var _inventory: InventoryUI
@export var _inventory_component: InventoryComponent

@export_group("States references")
@export var idle_state: IdleState
@export var smack_state: SmackState
@export var pick_up_state: PickUpState
@export var equipment_state: EquipmentState

func _ready() -> void:
	idle_state.initialize(_inventory) # Fix for weird missing reference bug
	pick_up_state.initialise(_inventory_component, _inventory)
	equipment_state.initialise(_inventory_component, _inventory)
	smack_state.initialise(_inventory)

func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var extension_from_top = get_window().content_scale_size.y-_max_vertical_extension
	global_position = Vector2(mouse_pos.x, max(extension_from_top, mouse_pos.y))
	
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
