extends Sprite2D

@export var _splat_duration: float = 60.0

func _ready() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, _splat_duration)
	await tween.finished
	queue_free()
