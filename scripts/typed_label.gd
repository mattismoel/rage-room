class_name TypedLabel
extends Label

signal text_changed(text: String)

## The standardised amount of characters making up a word.
const CHARS_PER_WORD = 5

signal finished
# signal wrote_letter

## The amount of words written per minute (WPM). 
@export var _wpm: float = 300.0

## The maximum variance of the base WPM (in percentage of base WPM)
@export var _wpm_variance_ratio: float = 0.0

## Whether or not the label should write writing automatically. If set to false,
## the 'write()' method must be called on the label.
@export var _auto_start: bool = false

@export_group("Audio")
## The sound to play when letters are typed. If left null, no audio is played.
@export var _typing_sound: AudioStream

## The base pitch scale of the typing sound.
@export var _pitch_scale: float = 1.0

## The max allowed variance in pitch scale per letter typed.
@export var _pitch_scale_variance: float = 0.0
@export_range(-80.0, 24.0, 0.05, "suffix:dB", "exp") var _volume: float

var _initial_text: String
var _audio_stream_player: AudioStreamPlayer

func _ready() -> void:
	_initial_text = text
	text = ""

	if _is_audible():
		_audio_stream_player = AudioStreamPlayer.new()
		add_child(_audio_stream_player)
		_audio_stream_player.stream = _typing_sound
		_audio_stream_player.volume_db = _volume


	if _auto_start: 
		write(_initial_text)
		return

## Begins writing the labels text.
## The labels text can be overridden with the optional argument 's'.
func write(s: String = "") -> void:
	## We must make sure that either the argument 's' is passed, or that the initial label text is set.
	assert((s == "" && _initial_text != "") || (s != ""), "Input string or TypedLabel.text must be set when calling method 'write()'!")

	text = ""
	var text_to_write := s if s != "" else _initial_text

	for letter in text_to_write:
		await _type_letter(letter)

	finished.emit()

func _type_letter(letter: String) -> void:
	text += letter
	text_changed.emit(text)

	## Skip spaces.
	if letter == " ":
		return

	if _is_audible(): 
		_play_typing_sound()

	var delay := _calculate_delay(_wpm, _wpm_variance_ratio)
	await get_tree().create_timer(delay).timeout

## Checks wheter or not the label should be audible.
##
## The label is considered audible when the typing sound is not null.
func _is_audible() -> bool:
	return _typing_sound != null

## Plays the defined typing sound.
func _play_typing_sound() -> void:
	assert(_is_audible(), "Attempted to play typing sound, but label is not audible!")
	assert(_audio_stream_player != null, "Attempted to play typing sound on null AudioStreamPlayer!")

	var random_pitch_scale = _pitch_scale + randf_range(-_pitch_scale_variance * 0.5, _pitch_scale_variance * 0.5)

	_audio_stream_player.pitch_scale = random_pitch_scale
	_audio_stream_player.play()

## Calculates the duration of which to wait before typing the next character.
func _calculate_delay(wpm: float, variance_ratio: float = 0.0) -> float:
	var cps := _calculate_cps(wpm)
	var base_delay := (1.0 / cps)
	var variance := base_delay * randf_range(-variance_ratio, variance_ratio)
	var delay := base_delay + variance
	return delay

## Calculates the amount of characters per second based on the input WPM.
func _calculate_cps(wpm: float) -> float:
	return (wpm * CHARS_PER_WORD) / 60.0
