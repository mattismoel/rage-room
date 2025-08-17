extends Control

@export_file("*.tscn") var _game_file

@export var _restart_button: Button
@export var _quit_button: Button

@export_group("Audio")
@export var _audio_player: AudioStreamPlayer
@export var _pitch_variance_magitude: float = 0.5
@export var _pitch_variance_speed: float = 0.5

var _time_since_start: float = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_audio_player.play()

	_restart_button.pressed.connect(_on_restart_button_pressed)
	_quit_button.pressed.connect(_on_quit_button_pressed)

func _process(delta: float) -> void:
	_time_since_start += delta
	_audio_player.pitch_scale = 1.0 + sin(_time_since_start * _pitch_variance_speed) * _pitch_variance_magitude

func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file(_game_file)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
