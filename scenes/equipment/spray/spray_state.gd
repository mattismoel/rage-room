class_name SprayState
extends State

@export var effectiveness: float = 3

@export_category("References")
@export var _idle_state: State
@export var _hit_area: Area2D

@export var _animation_player: AnimationPlayer
@export var _audio_player: AudioStreamPlayer2D
@export var _pitch_variance: float = 0.05

func enter() -> void:
	super()

	_animation_player.play("spray")
	await _animation_player.animation_finished
	changed_state.emit(_idle_state)

func play_sound() -> void:
	_audio_player.pitch_scale = 1.0 + randf_range(-_pitch_variance * 0.5, _pitch_variance * 0.5)
	_audio_player.play()

func exit() -> void:
	super()
	_audio_player.stop()
	
func _spray_intersecting_insects() -> void:
	var overlapping_areas: Array[Area2D] = _hit_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area.get_parent() is Insect:
			var insect = area.get_parent()
			insect.slow_down(effectiveness)
