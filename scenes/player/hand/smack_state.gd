class_name SmackState
extends State

var _inventory: Control

@export var _hit_area: Area2D
@export var _idle_state: IdleState
@export var _pick_up_state: PickUpState
@export var _animation_player: AnimationPlayer

func enter() -> void:
	visible = true
	_animation_player.play("smack")

	await _animation_player.animation_finished
	changed_state.emit(_idle_state)

	if _is_mouse_in_inventory():
		changed_state.emit(_pick_up_state)

func exit() -> void:
	super()
	visible = false

func initialise(inventory: Control) -> void:
	_inventory = inventory
	pass

func _kill_intersecting_insects() -> void:
	var overlapping_areas: Array[Area2D] = _hit_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area.get_parent() is Insect:
			InsectManager.kill(area.get_parent())

func _is_mouse_in_inventory() -> bool:
	var mouse_pos := _inventory.get_global_mouse_position()
	var inventory_rect := _inventory.get_rect()

	return inventory_rect.has_point(mouse_pos)
