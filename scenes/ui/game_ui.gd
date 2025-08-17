class_name GameUI
extends Control

signal inventory_entry_entered(entry: EquipmentEntry)
signal inventory_entry_exited(entry: EquipmentEntry)


@export var cursor: Cursor
@export var inventory: InventoryUI

@export var _player_health_component: HealthComponent

@export var _currency_label: Label
@export var _health_label: Label
@export var _health_bar: HealthBar

@export_group("Callouts")
@export var _speech_bubble: SpeechBubble
@export var _callouts: Array[String] = []
@export var _callout_timer: Timer
@export var _callout_hang_duration: float = 3.0
@export var _mouth_animation_player: AnimationPlayer
@export var _talk_duration: float = 1.0

@export_group("Audio")
@export var _cash_required_for_register: float = 2.0
@export var _register_audio_player: AudioStreamPlayer
@export var _register_buffer_duration: float = 0.1

var _prev_balance: float
var _balance_accumulator: float = 0.0
var _register_timer: Timer

var _is_talking: bool = false

func _ready() -> void:
	Globals.said.connect(say)

	_health_bar.max_value = _player_health_component.max_health
	_health_bar.value = _player_health_component.initial_health

	inventory.entry_entered.connect(inventory_entry_entered.emit)
	inventory.entry_exited.connect(inventory_entry_exited.emit)

	_register_timer = Timer.new()
	_register_timer.wait_time = _register_buffer_duration
	_register_timer.one_shot = true
	_register_timer.timeout.connect(_on_register_timer_timeout)

	_callout_timer.timeout.connect(_on_callout_timer_timeout)
	add_child(_register_timer)

func update_balance(value: float) -> void:
	var diff := value - _prev_balance

	if diff > 0.0:
		_balance_accumulator += diff
		_register_timer.start()
	else:
		_register_timer.start()

		
	inventory.enable_affordable_slots(value)

	_currency_label.text = "$%d" % value
	_prev_balance = value

func update_health(new_health: float) -> void:
	_health_bar.set_health(new_health)
	_health_label.text = "%dHP" % roundi(new_health)

func _on_register_timer_timeout() -> void:
	if _balance_accumulator >= _cash_required_for_register:
		_register_audio_player.play()
	_balance_accumulator = 0.0

func _on_callout_timer_timeout() -> void:
	var health_ratio := _player_health_component.calculate_health_ratio()
	var idx := int(round((_callouts.size() - 1) * health_ratio))
	var callout := _callouts[idx]
	say(callout)

func say(text: String) -> void:
	_callout_timer.stop()

	if _is_talking:
		await _speech_bubble.close()

	_is_talking = true

	_mouth_animation_player.play("talk")
	await _speech_bubble.write(text)
	await get_tree().create_timer(_talk_duration).timeout
	_mouth_animation_player.play("idle")
	await get_tree().create_timer(_callout_hang_duration).timeout
	await _speech_bubble.close()

	_is_talking = false
	_callout_timer.start()
