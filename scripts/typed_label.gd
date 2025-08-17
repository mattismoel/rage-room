class_name TypedLabel
extends Label

signal finished
signal wrote_letter

@export var _rate: float = 40.0
@export var _randomness: float = 0.0
@export var _auto_start: bool = false

var _stopped: bool = false

func _ready() -> void:
	if !_auto_start: return
	start()

func start() -> void:
	var init_text = text

	text = ""
	for letter in init_text:
		if _stopped: return 
		await _type_letter(letter)

	finished.emit()

func stop() -> void:
	_stopped = true
	pass

func _type_letter(letter: String) -> void:
	if letter == " ":
		text += letter
		return

	text += letter
	wrote_letter.emit()
	await get_tree().create_timer(1.0 / _rate + randf_range(-_randomness / 2.0, _randomness / 2.0)).timeout
