class_name SwatState
extends State

@export var _idle_state: State
@export var _hit_area: Area2D
@export var _animation_player: AnimationPlayer

func enter() -> void:
	super()

	_animation_player.play("swat")
	await _animation_player.animation_finished
	changed_state.emit(_idle_state)
	
func _kill_intersecting_insects() -> void:
	var overlapping_areas: Array[Area2D] = _hit_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area.get_parent() is Insect:
			InsectManager.kill(area.get_parent())
