extends State

@export var _spray_state: SprayState
@export var _animation_player: AnimationPlayer

func enter() -> void:
	super()
	_animation_player.play("idle")

func exit() -> void:
	super()

func input(event) -> void:
	if event.is_action_pressed("interact"):
		changed_state.emit(_spray_state)
