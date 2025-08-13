class_name IntensityManager
extends Node

## Emitted whenever the intesity changes. It contains the newly calculated 
## intensity.
signal intensity_changed(new_intensity: float)

## The current intensity.
var intensity: float = 0.0

func _ready() -> void:
	InsectManager.count_changed.connect(_on_insect_count_change)

func _on_insect_count_change(total_count: int) -> void:
	var new_intensity := _calculate_intensity(total_count, InsectManager.MAX_INSECT_COUNT)
	_set_intensity(new_intensity)

func _calculate_intensity(insect_count: int, max_insect_count: int) -> float:
	return float(insect_count) / float(max_insect_count)

func _set_intensity(new_intensity: float) -> void:
	intensity = clampf(new_intensity, 0.0, 1.0)
	intensity_changed.emit(new_intensity)
