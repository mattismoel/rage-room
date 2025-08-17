extends State

@export var _spray_state: SprayState
@export var _animation_player: AnimationPlayer
@export var _struggle_component: StruggleComponent

func enter() -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	global_position = _struggle_component.get_struggling_mouse_pos(mouse_pos)
	super()
	_animation_player.play("idle")

func exit() -> void:
	super()

func input(event) -> void:
	if event.is_action_pressed("interact"):
		changed_state.emit(_spray_state)
