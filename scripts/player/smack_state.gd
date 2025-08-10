extends State
@export var selection_area: CollisionObject2D

func enter() -> void:
	print("smack")
	visible = true
	
	var overlapping_areas: Array[Area2D] = selection_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area.get_parent().is_in_group("insects"):
			InsectManager.kill(area.get_parent())
	
	await get_tree().create_timer(1.0).timeout
	change_state_by_name.emit("Idle")
	
func exit() -> void:
	super()
	visible = false
