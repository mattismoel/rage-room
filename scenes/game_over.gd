extends Control

@export_group("Audio")
@export var _audio_player: AudioStreamPlayer
@export var _pitch_variance_magitude: float = 0.5
@export var _pitch_variance_speed: float = 0.5

var _time_since_start: float = 0.0

func _ready() -> void:
	_audio_player.play()

func _process(delta: float) -> void:
	_time_since_start += delta
	_audio_player.pitch_scale = 1.0 + sin(_time_since_start * _pitch_variance_speed) * _pitch_variance_magitude
