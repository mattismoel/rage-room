extends Insect

@export var _speed: float = 25.0

func target(t: Target) -> void:
	super(t)

	var tween := create_tween()
	var distance := global_position.distance_to(t.global_position)
	var duration := distance / _speed

	tween.tween_property(self, "global_position", t.global_position, duration)
