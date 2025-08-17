extends Button
class_name AudibleButton

@export var _audio_player: AudioStreamPlayer

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	_audio_player.play()

