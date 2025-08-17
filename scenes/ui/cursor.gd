class_name Cursor
extends Control

@export var _texture_rect: TextureRect
@export var _cursor_sprite_dict: Dictionary[Input.CursorShape, CursorEntry] = {}

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		global_position = event.global_position

	var cursor_shape := Input.get_current_cursor_shape()

	var entry := _cursor_sprite_dict[cursor_shape]
	_texture_rect.texture = entry.texture
	_texture_rect.position = entry.offset
