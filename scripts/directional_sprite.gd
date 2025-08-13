class_name DirectionalSprite
extends Sprite2D

## The node to target for its direction.
@export var _target: Node2D
@export var _animation_tree: AnimationTree

var _previous_target_position: Vector2
var _previous_target_direction: Vector2

func _process(_delta: float) -> void:
	var direction := _previous_target_position.direction_to(_target.global_position).normalized()
	if direction == Vector2.ZERO:
		direction = _previous_target_direction

	_animation_tree["parameters/blend_position"] = Vector2(direction.x, -direction.y)
	_previous_target_position = _target.global_position
	_previous_target_direction = direction

## Returns the normalized direction to the assigned target.
func _direction_to_target() -> Vector2:
	var direction := _previous_target_position\
		.direction_to(_target.global_position)\
		.normalized()

	if direction == Vector2.ZERO:
		return _previous_target_position

	return direction
