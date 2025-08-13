class_name SmackState
extends State

@export var hit_area: Area2D
@export var idle_state: IdleState
@export var _animation_player: AnimationPlayer

func enter() -> void:
	visible = true
	
	_animation_player.play("smack")

	await _animation_player.animation_finished
	changed_state.emit(idle_state)

func exit() -> void:
	super()
	visible = false

func _kill_intersecting_insects() -> void:
	var overlapping_areas: Array[Area2D] = hit_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area.get_parent() is Insect:
			InsectManager.kill(area.get_parent())
	pass
