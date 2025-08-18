class_name Target
extends Area2D 

## The weight (importance) of the target.
@export var weight: float = 1.0

## The consumable associated with the target.
@export var consumable: ConsumableEntry

@export var _progress_sprite: ProgressSprite

@export_group("References")
@export var _health_component: HealthComponent

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	_health_component.health_changed.connect(_on_health_changed)

	var initial_progress := _health_component.calculate_health_ratio()
	_progress_sprite.set_progress(initial_progress)

## Gets a random point on the targets circle shape perimeter.
##
## The random position selection is limited to the visible part of the
## perimiter, with respect to the direction.
func get_random_perimeter_point_from_point(p: Vector2) -> Vector2:
	var direction := p.direction_to(global_position)
	var shape := _get_collision_shape()

	assert(shape.shape is CircleShape2D, "The shape must be of type CircleShape2D to find point on perimeter.")

	var circle_shape := shape.shape as CircleShape2D
	var perpendicular_direcion = Vector2(-direction.y, direction.x)
	var random_direction := perpendicular_direcion.rotated(randf() * PI)

	var perimeter_point := global_position + random_direction * circle_shape.radius

	return perimeter_point

func _on_area_entered(area: Area2D) -> void:
	var parent := area.get_parent()

	if parent is Insect:
		parent.took_bite.connect(_health_component.take_damage)
		return

func _get_collision_shape() -> CollisionShape2D:
	for child in get_children():
		if child is CollisionShape2D: 
			return child
	return null

func _on_health_changed(health: float) -> void:
	var health_ratio := _health_component.calculate_health_ratio()
	_progress_sprite.set_progress(health_ratio)

func is_empty() -> bool:
	return _health_component.health <= 0
