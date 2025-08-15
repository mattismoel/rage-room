class_name Target
extends Area2D 


## The weight (importance) of the target.
@export var weight: float = 1.0

## The consumable associated with the target.
@export var consumable: ConsumableEntry

@export var _damage_per_insect: float = 1.0

@export_group("References")
@export var _health_component: HealthComponent
@export var _timer: Timer

var _contained_insects: Array[Insect] = []

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	_timer.timeout.connect(_on_timer_timeout)

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
		_contained_insects.append(parent)
		parent.killed.connect(_on_insect_killed)
		return


func _on_timer_timeout() -> void:
	if _contained_insects.size() <= 0: 
		return
	var total_damage := _contained_insects.size() * _damage_per_insect
	_health_component.take_damage(total_damage)


func _on_insect_killed(insect: Insect) -> void:
	var index := _contained_insects.find(insect)
	assert(index != -1, "The killed insect could not be found in the targets contained insects.")
	_contained_insects.remove_at(index)

func _get_collision_shape() -> CollisionShape2D:
	for child in get_children():
		if child is CollisionShape2D: 
			return child
	return null
