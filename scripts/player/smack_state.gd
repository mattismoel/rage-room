class_name SmackState
extends State

@export var hit_area: Area2D
@export var idle_state: IdleState

func enter() -> void:
	visible = true
	print("SMACK!")
	
	var overlapping_areas: Array[Area2D] = hit_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area.get_parent() is Insect:
			InsectManager.kill(area.get_parent())

func input(event: InputEvent) -> void:
	if event.is_action_released("interact"):
		change_state.emit(idle_state)

func exit() -> void:
	super()
	visible = false
