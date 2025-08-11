class_name SmackState
extends State
@export var selection_area: CollisionObject2D

@export var idle_state: IdleState

func enter() -> void:
	print("SMACK!")
	visible = true
	
	var overlapping_areas: Array[Area2D] = selection_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area.get_parent() is Insect:
			InsectManager.kill(area.get_parent())
	
	await get_tree().create_timer(1.0).timeout
	change_state.emit(idle_state)
	
func exit() -> void:
	super()
	visible = false
