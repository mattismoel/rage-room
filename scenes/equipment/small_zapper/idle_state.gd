extends State

@export var _zap_state: ZapState

func enter() -> void:
	super()
	show()

func exit() -> void:
	super()
	hide()

func input(event) -> void:
	if event.is_action_pressed("interact"):
		changed_state.emit(_zap_state)
