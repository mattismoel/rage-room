extends Insect

## The base walk speed of the ant.
@export var _base_speed: float = 16

## The max amount of variance in speed.
@export var _speed_variance: float = 8.0
@export var _animation_player: AnimationPlayer

@export_group("Waypoint System")
## The max distance from the straight line to the target, that the ant deviates. 
@export var _wiggle_width: float = 12.0

## The target segment length between waypoints.
@export var _segment_length: float = 64.0

## The amount of time to wait between waypoints.
@export var _waypoint_wait_duration: float = 0.75

## The max amount of variance to wait between waypoints.
@export var _waypoint_wait_duration_variance: float = 0.5

var current_tween: Tween
var current_speed_scale: float

func target(t: Target) -> void:
	var target_pos := t.get_random_perimeter_point_from_point(global_position)

	var segment_count := _calculate_segment_count(global_position, target_pos, _segment_length)

	var waypoints := _generate_waypoints(global_position, target_pos, segment_count, _wiggle_width)
	var speed := _calculate_randomized_speed(_base_speed, _speed_variance)
	
	## Saves a reference of the tween, so it can be stopped in case of slow down
	current_tween = get_tree().create_tween()

	var prev_pos := global_position
	for wp_pos in waypoints:
		var wait_duration := _calculate_random_wait_duration(_waypoint_wait_duration, _waypoint_wait_duration_variance)
		prev_pos = _add_waypoint_tween_step(prev_pos, wp_pos, wait_duration, speed)

func slow_down(effectiveness: float):
	## Calculate how much the insect should be slowed down
	assert(effectiveness != 0 or _resistance != 1, "Invalid resistance or effectiveess resulting in divide by 0")
	var new_speed_scale := 1/(effectiveness*(1-_resistance))
	current_speed_scale = new_speed_scale
	
	var deccleration_tween = create_tween()
	deccleration_tween.set_parallel()
	deccleration_tween.tween_method(current_tween.set_speed_scale, current_speed_scale, new_speed_scale, 1)
	deccleration_tween.tween_property(_animation_player, "speed_scale", new_speed_scale, 1)
	deccleration_tween.tween_property(self, "modulate", Color.GREEN, 1)
	
	deccleration_tween.tween_interval((1-_resistance)*BASE_SLOW_DOWN_TIME)
	await deccleration_tween.finished
	
	var accleration_tween = create_tween()
	accleration_tween.tween_property(self, "modulate", Color.WHITE, 1)
	accleration_tween.tween_method(current_tween.set_speed_scale, new_speed_scale, 1 , 1)
	accleration_tween.tween_property(_animation_player, "speed_scale", 1, 1)

## Returns a randomized speed given a variance. 
func _calculate_randomized_speed(speed: float, variance: float) -> float:
	return speed + randf_range(-variance * 0.5, variance * 0.5)

## Generates the waypoint locations between "start" and "end" given the segment
## count. The waypoint randomness is based on the wiggle_width, that determines
## by how many pixels the ant's path can deviate from the base path.
func _generate_waypoints(start_pos: Vector2, end_pos: Vector2, segment_count: int, wiggle_width: float) -> Array[Vector2]:
	var prev_pos := start_pos

	var distance := prev_pos.distance_to(end_pos)
	var direction := start_pos.direction_to(end_pos)
	var perpendicular := Vector2(-direction.y, direction.x)
	var segment_size := distance / segment_count

	var waypoints: Array[Vector2] = []

	for i in range(segment_count):
		var next_pos: Vector2

		if i >= segment_count - 1:
			next_pos = end_pos
		else:
			next_pos = prev_pos + (direction * segment_size)
			next_pos += perpendicular * (randf_range(-1.0, 1.0) * wiggle_width)

		waypoints.append(next_pos)
		prev_pos = next_pos

	return waypoints

## Adds a step for moving from the "from_pos" to the "to_pos" to the input 
## tween, as well as adding a wait interval to the end, pausing the sequence 
## until next step is run.
func _add_waypoint_tween_step(from_pos: Vector2, to_pos: Vector2, wait_duration: float, speed: float) -> Vector2:
	var distance := from_pos.distance_to(to_pos)
	var duration := distance / speed
	
	current_tween.tween_property(self, "global_position", to_pos, duration)
	current_tween.tween_interval(wait_duration)

	return to_pos

## Calculates a random duration given the base wait duration and a maximum 
## variance.
func _calculate_random_wait_duration(wait_duration: float, variance: float) -> float:
	return wait_duration + randf_range(-variance * 0.5, variance * 0.5)

## Calculates the amount of segments that should be used between "from_pos" and
## "to_pos", given the base segment length.
func _calculate_segment_count(from_pos: Vector2, to_pos: Vector2, segment_length: float) -> int:
	var distance_to_target := from_pos.distance_to(to_pos)
	var segment_count := int(floor(distance_to_target / segment_length))
	return segment_count
