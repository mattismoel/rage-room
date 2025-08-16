class_name ProgressSprite
extends Sprite2D

func set_progress(p: float) -> void:
	p = clamp(p, 0.0, 1.0)

	var idx := int(round(p * (hframes - 1)))
	frame = idx
