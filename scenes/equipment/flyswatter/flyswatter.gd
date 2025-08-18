extends Equipment

@export var _struggle_component: StruggleComponent

func _ready() -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	global_position = _struggle_component.get_struggling_mouse_pos(mouse_pos)
