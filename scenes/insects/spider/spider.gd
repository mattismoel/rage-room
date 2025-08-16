extends Insect

@export var _base_speed: float = 8.0
@export var _hitbox: Area2D
@export var _animation_player: AnimationPlayer

@onready var _speed: float = _base_speed
@onready var _screen_size := Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height"),
)

var _direction: Vector2
var _velocity: Vector2

func _ready() -> void:
	super()
	_hitbox.area_entered.connect(_on_area_entered)

	var _random_point := Vector2(
		randf_range(0, _screen_size.x),
		randf_range(0, _screen_size.y),
	)

	_direction = global_position.direction_to(_random_point)


func _process(delta: float) -> void:
	_velocity = _direction * _speed
	translate(_velocity * delta)

	if !_is_on_screen(): return

	if global_position.x > _screen_size.x || global_position.x < 0.0:
		_direction.x = -_direction.x

	if global_position.y > _screen_size.y || global_position.y < 0.0:
		_direction.y = -_direction.y


func slow_down(effectiveness: float) -> void:
	## Calculate how much the insect should be slowed down
	assert(effectiveness != 0 or _resistance != 1, "Invalid resistance or effectiveess resulting in divide by 0")
	var new_speed_scale := 1/(effectiveness*(1-_resistance))

	var deccleration_tween = create_tween()
	deccleration_tween.set_parallel()
	deccleration_tween.tween_property(self, "_speed", new_speed_scale*_speed, 1)
	deccleration_tween.tween_property(self, "modulate", Color.GREEN, 1)
	deccleration_tween.tween_property(_animation_player, "speed_scale", new_speed_scale, 1)
	
	deccleration_tween.tween_interval((1-_resistance)*BASE_SLOW_DOWN_TIME)
	await deccleration_tween.finished
	
	var accleration_tween = create_tween()
	accleration_tween.tween_property(self, "_speed", _base_speed, 1)
	accleration_tween.tween_property(self, "modulate", Color.WHITE, 1)
	accleration_tween.tween_property(_animation_player, "speed_scale", 1, 1)
	
func _on_area_entered(area: Area2D) -> void:
	if area is not Target: return
	_direction = _calculate_new_direction(_direction)

func _calculate_new_direction(direction: Vector2) -> Vector2:
	var perpendicular := Vector2(-direction.y, direction.x)
	return perpendicular.rotated(randf() * PI)

func _is_on_screen() -> bool:
	return global_position.x <= _screen_size.x && global_position.x > 0.0\
		&& global_position.y <= _screen_size.y && global_position.y > 0.0
