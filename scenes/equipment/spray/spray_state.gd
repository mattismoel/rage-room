class_name SprayState
extends State

@export var _idle_state: State
@export var _hit_area: Area2D
@export var _particle_system: CPUParticles2D
@export var _animation_player: AnimationPlayer

func enter() -> void:
	super()
	show()

	_animation_player.play("spray")
	await _animation_player.animation_finished
	changed_state.emit(_idle_state)

func exit() -> void:
	super()
	hide()
	
func _kill_intersecting_insects() -> void:
	var overlapping_areas: Array[Area2D] = _hit_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area.get_parent() is Insect:
			InsectManager.kill(area.get_parent())
