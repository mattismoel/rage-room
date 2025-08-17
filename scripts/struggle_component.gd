class_name StruggleComponent
extends Node2D

@export var slave: Node2D

@export var _max_vertical_arm_extension: float = 110
@export var _struggle_extension: float = 80
@onready var _logistic_constant: float = -log((_max_vertical_arm_extension/\
_struggle_extension)-1)/(_struggle_extension-_max_vertical_arm_extension/2)

func _ready() -> void:
	assert(slave != null, "No slave specified")
	assert(!is_nan(_logistic_constant), "Invalid values for arm extension")

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion: return

	var mouse_pos = event.position
	slave.global_position = get_struggling_mouse_pos(mouse_pos)

## Converts regular coordinates to godot coordinates and vice versa
func _coords_convert(in_cords: float) -> float:
	return get_window().content_scale_size.y - in_cords

## Returns the position of the mouse after struggle has been applied
func get_struggling_mouse_pos(mouse_pos: Vector2) -> Vector2:
	return Vector2(mouse_pos.x, apply_struggle(mouse_pos.y))

## Calculates the impact of struggle at the given vertical position
## and returns a new vertical position (position.y)
func apply_struggle(y_pos: float) -> float:
	var vert_extension := _coords_convert(y_pos)
	## Arm is limited by a logistic function if extended past the struggle bound
	if vert_extension > _struggle_extension:
		vert_extension = _max_vertical_arm_extension/(1+exp(-_logistic_constant\
		*(vert_extension-_max_vertical_arm_extension/2)))
		
	return _coords_convert(vert_extension)
