extends State

@export var _zap_state: ZapState
@export var _struggle_component: StruggleComponent

func enter() -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	global_position = _struggle_component.get_struggling_mouse_pos(mouse_pos)
	super()
	show()

func exit() -> void:
	super()
	hide()

func input(event) -> void:
	if event.is_action_pressed("interact"):
		changed_state.emit(_zap_state)
