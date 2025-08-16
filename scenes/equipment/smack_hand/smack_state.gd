class_name SmackState
extends State

@export var _idle_state: State
@export var _hit_area: Area2D
@export var _animation_player: AnimationPlayer

@export var _damage_per_smack: float = 10.0

func enter() -> void:
	super()
	show()

	_animation_player.play("smack")
	_damage_intersecting_insects(_damage_per_smack)
	await _animation_player.animation_finished
	changed_state.emit(_idle_state)

func exit() -> void:
	super()
	hide()
	
func _damage_intersecting_insects(damage: float) -> void:
	var overlapping_areas: Array[Area2D] = _hit_area.get_overlapping_areas()
	for area in overlapping_areas:
		var parent := area.get_parent()
		if parent is Insect:
			parent.take_damage(damage)
