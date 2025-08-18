@tool
class_name DaycycleComponent
extends Node

signal day_progressed(days_progressed: int)
signal intensity_changed(new_intensity: float)

@export_range(0.0, 1.0) var _initial_time_of_day: float = 0.25:
	set(new_value):
		_initial_time_of_day = new_value

		_time_of_day = _initial_time_of_day * _secs_per_day
		var v := _time_of_day / _secs_per_day
		intensity = _calculate_intensity(v)
		intensity_changed.emit(v)

@export var _secs_per_day: float = 60.0
@onready var _time_of_day: float = _initial_time_of_day * _secs_per_day

var intensity: float
var _prev: float = 0.0
var _day_count: int = 0

func _ready() -> void:
	var day_progress :=  _time_of_day / _secs_per_day
	_prev = day_progress

func _process(delta: float) -> void:
	_time_of_day = fmod(_time_of_day + delta, _secs_per_day)

	var day_progress = _time_of_day / _secs_per_day

	if abs(_prev - day_progress) >= 0.5:
		_day_count += 1
		day_progressed.emit(_day_count)
		
	_prev = day_progress
	intensity = _calculate_intensity(day_progress)

func _calculate_intensity(v: float) -> float:
	return (1.0 - cos(v * 2.0 * PI)) * 0.5
