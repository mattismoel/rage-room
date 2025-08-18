extends State

@export var _swat_state: SwatState
@export var _animation_player: AnimationPlayer
@export var _struggle_component: StruggleComponent

func enter() -> void:
	super()
	_animation_player.play("idle")

func exit() -> void:
	super()

func input(event) -> void:
	if event.is_action_pressed("interact"):
		changed_state.emit(_swat_state)
