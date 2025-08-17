class_name SmackState
extends State

@export var _hold_duration: float = 1.0
@export var _smack_trauma: float = 0.25
@export var _transition_state: State

@export var _hit_area: Area2D
@export var _animation_player: AnimationPlayer
@export var _audio_player: AudioStreamPlayer2D

@export var _struggle_component: StruggleComponent

@export_group("Audio")
@export var _damage_per_smack: float = 10.0
@export var _pitch_variance: float = 0.05

func enter() -> void:
	super()

	var mouse_pos := get_viewport().get_mouse_position()
	global_position = _struggle_component.get_struggling_mouse_pos(mouse_pos)

	show()
	_animation_player.play("smack")

func exit() -> void:
	super()
	hide()

func _hit_table() -> void:
	_audio_player.pitch_scale = 1.0 + randf_range(-_pitch_variance * 0.5, _pitch_variance * 0.5)
	_audio_player.play()
	Globals.camera.add_trauma(_smack_trauma)
	_damage_intersecting_insects(_damage_per_smack)
	await get_tree().create_timer(_hold_duration).timeout
	changed_state.emit(_transition_state)
	
func _damage_intersecting_insects(damage: float) -> void:
	var overlapping_areas: Array[Area2D] = _hit_area.get_overlapping_areas()
	for area in overlapping_areas:
		var parent := area.get_parent()
		if parent is Insect:
			parent.take_damage(damage)
