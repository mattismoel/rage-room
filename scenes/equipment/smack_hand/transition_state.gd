extends State

@export var _idle_state: State
@export var _struggle_component: StruggleComponent
@export var _move_speed: float = 750.0
@export var _smack_state: Node2D

@export var _ease: Tween.EaseType = Tween.EASE_OUT
@export var _trans: Tween.TransitionType = Tween.TRANS_SPRING

func enter() -> void:
	super()
	show()

	var mouse_pos := get_global_mouse_position()

	var new_pos := _struggle_component.get_struggling_mouse_pos(mouse_pos)
	var current_pos := _smack_state.global_position
	global_position = current_pos

	var distance := current_pos.distance_to(new_pos)
	var duration := distance / _move_speed

	var tween := create_tween()
	tween.tween_property(self, "global_position", new_pos, duration)\
		.set_trans(_trans)\
		.set_ease(_ease)

	await tween.finished

	changed_state.emit(_idle_state)

func exit() -> void:
	super()
	hide()
