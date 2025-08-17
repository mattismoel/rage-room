class_name ZapState
extends State

@export var _damage_per_zap: float = 10.0
@export var _pitch_variance: float = 0.05

@export var _idle_state: State
@export var _hit_area: Area2D
@export var _animation_player: AnimationPlayer
@export var _audio_player: AudioStreamPlayer2D

func enter() -> void:
	super()
	show()

	_animation_player.play("zap")
	await _animation_player.animation_finished
	changed_state.emit(_idle_state)

func exit() -> void:
	super()
	hide()

func electrocute() -> void:
	var insects := _get_intersecting_insects()
	for insect in insects:
		insect.slow_down(15)
		
	_audio_player.pitch_scale = 1.0 + randf_range(-_pitch_variance * 0.5, _pitch_variance * 0.5)
	_audio_player.play()
	
func damage_insects() -> void:
	var insects := _get_intersecting_insects()
	for insect in insects:
		insect.take_damage(_damage_per_zap)

func _get_intersecting_insects() -> Array[Insect]:
	var insects: Array[Insect] = []
	var overlapping_areas: Array[Area2D] = _hit_area.get_overlapping_areas()
	for area in overlapping_areas:
		var parent := area.get_parent()
		if parent is Insect:
			insects.append(parent)
	return insects
