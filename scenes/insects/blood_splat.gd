extends Sprite2D

@export var _splat_duration: float = 60.0
@export var _splat_streams: Array[AudioStream] = []
@export var _audio_stream_player: AudioStreamPlayer2D
@export var _pitch_scale_variance: float = 0.1

func _ready() -> void:
	assert(_splat_streams.size() > 0, "There must be at least one splat sound.")

	_play_random_splat_sound()

	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, _splat_duration)
	await tween.finished
	queue_free()

func _play_random_splat_sound() -> void:
	var stream: AudioStream = _splat_streams.pick_random()
	_audio_stream_player.stream = stream
	var pitch_scale := 1.0 + randf_range(-_pitch_scale_variance * 0.5, _pitch_scale_variance * 0.5)
	_audio_stream_player.pitch_scale = pitch_scale
	_audio_stream_player.play()
	pass
