extends State

@export var selection_area: CollisionObject2D

@export var smack_state: State
@export var equipment_state: EquipmentState

func enter() -> void:
	super()
	visible = true
	#selected_area.area_entered.connect(area_entered)

func input(event) -> void:
	if event.is_action_pressed("interact"):
		print("Mouse pressed at: ", event.position)
		
		# Switch to smack state
		change_state.emit(smack_state)
		
	if event is InputEventKey and event.pressed:
		## Check if keypress is a number between 0 and 9
		if event.keycode >= KEY_2 and event.keycode <= KEY_9:
			var digit_pressed: int = -KEY_2 + event.keycode
			
			# Switch to equipment state after setting equipment
			equipment_state.set_equipment_from_index(digit_pressed)
			change_state.emit(equipment_state)

func exit() -> void:
	super()
	visible = false

#func area_entered(area: Area2D) -> void:
#	print(area.name)
