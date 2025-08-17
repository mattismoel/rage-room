extends State

@export var _smack_state: State
@export var _animation_player: AnimationPlayer

func enter() -> void:
	super()
	show()
	_animation_player.play("idle")

func exit() -> void:
	super()
	hide()

func input(event) -> void:
	if !active: return
	if event.is_action_pressed("interact"):
		changed_state.emit(_smack_state)

func _on_state_machine_disabled() -> void:
	super()
	set_process(false)
