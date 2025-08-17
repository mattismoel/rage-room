class_name SpeechBubble
extends Panel

@export_multiline var _text: String

@export var _label: TypedLabel
@export var _audio_player: AudioStreamPlayer
@export var _auto_start: bool = false
@export var _hover_transparency: float = 0.75

var is_writing: bool = false

func _ready() -> void:
	_label.wrote_letter.connect(_on_wrote_letter)
	pivot_offset = size
	await close()

	if _auto_start: 
		write(_text)

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func write(text: String) -> void:
	show()

	if is_writing:
		_label.stop()
		_label.text = ""

	is_writing = true
	var tween := create_tween()

	tween.tween_property(self, "modulate", Color.WHITE, 0.2)

	await tween.finished
	_label.text = text
	_label.start(text)
	await _label.finished
	is_writing = false

func close() -> void:
	var tween := create_tween()
	tween.set_parallel()

	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	await tween.finished

	_label.text = ""
	hide()

func _on_wrote_letter() -> void:
	_audio_player.play()

func _on_mouse_entered() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", _hover_transparency, 0.2)

func _on_mouse_exited() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2)

