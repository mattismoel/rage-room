class_name SpeechBubble
extends Panel

## The maximum amount of queues for the speech bubble.
const MAX_QUEUE_SIZE: int = 2

signal queue_finished

@export var _label: TypedLabel
@export var _hang_duration: float = 1.0
@export var _hover_transparency: float = 0.75
@export var _animation_player: AnimationPlayer

var is_speaking: bool = false
var _queue: Array[String] = []

func _ready() -> void:
	hide()

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	_label.text_changed.connect(_on_text_changed)

func add_to_queue(s: String) -> void:
	if _queue.size() >= MAX_QUEUE_SIZE: return

	_queue.append(s)
	pass

func _say(text: String) -> void:
	assert(text != "", "The input text of the SpeechBubble must not be empty!")

	if not visible:
		show()
		_animation_player.play("pop_in")
		await _animation_player.animation_finished

	await _label.write(text)

	await get_tree().create_timer(_hang_duration).timeout
	await stop()

func say_queue() -> void:
	if is_speaking: 
		await queue_finished

	is_speaking = true

	while _queue.size() > 0:
		var s = _queue.pop_front()
		if s == null: return
		await _say(s)

	is_speaking = false
	queue_finished.emit()

## Stops the speech bubble from speaking.
func stop() -> void:
	_animation_player.play("pop_out")
	await _animation_player.animation_finished
	hide()

## Calculates the vertical size required to fit the input text.
func _calculate_vertical_size(text: String) -> float:
	var _init_text = _label.text

	_label.text = text
	var vertical_size := _label.get_minimum_size().y
	_label.text = _init_text
	return vertical_size

func _on_mouse_entered() -> void:
	print("Entered")
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", _hover_transparency, 0.2)

func _on_mouse_exited() -> void:
	print("Exited")
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2)

func _on_text_changed(text: String) -> void:
	size.y = _calculate_vertical_size(text)
