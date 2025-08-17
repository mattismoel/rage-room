@tool
class_name AnimatableTextureRect
extends TextureRect

@export var _texture: AtlasTexture

@export var hframes: int = 1:
	set(v):
		v = max(v, 1)
		hframes = v
		set_frame(frame)

@export var vframes: int = 1:
	set(v):
		v = max(v, 1)
		vframes = v
		set_frame(frame)

@export var frame: int = 0:
	set(v):
		v = max(v, 0)
		set_frame(v)
		frame = v

func set_frame(idx: int) -> void:
	var frame_size := _calculate_frame_size()

	var row := floori(float(idx) / hframes)
	var col := idx - (row * hframes)

	_texture.region.size = frame_size
	_texture.region.position.x = frame_size.x * col
	_texture.region.position.y = frame_size.y * row

	texture = _texture
	pass

func _calculate_frame_size() -> Vector2:
	var frame_width := _texture.atlas.get_size().x / hframes
	var frame_height := _texture.atlas.get_size().y / vframes
	return Vector2(frame_width, frame_height)
