class_name SprayState
extends State

@export var slow_down_multiplier: float = 3
@export var health_damage: float = 10

@export_category("References")
@export var _idle_state: State
@export var _hit_area: Area2D
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
	
func _spray_intersecting_insects() -> void:
	var overlapping_areas: Array[Area2D] = _hit_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area.get_parent() is Insect:
			var insect = area.get_parent()
			insect.spray(slow_down_multiplier, health_damage)
