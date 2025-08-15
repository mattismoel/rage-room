class_name SmackState
extends State

var _inventory: InventoryUI
var _entered_inventory: bool

@export var _hit_area: Area2D
@export var _idle_state: IdleState
@export var _pick_up_state: PickUpState
@export var _animation_player: AnimationPlayer

var _game_ui: GameUI

func enter() -> void:
	visible = true
	_entered_inventory = false
	_animation_player.play("smack")
	
	await _animation_player.animation_finished
	if _entered_inventory: changed_state.emit(_pick_up_state)
	else: changed_state.emit(_idle_state)
	
func initialise(inventory: Control) -> void:
	_inventory = inventory
	_inventory.entry_entered.connect(func(_entry: EquipmentEntry): _entered_inventory = true)
	_inventory.entry_exited.connect(func(_entry: EquipmentEntry): _entered_inventory = false)

func exit() -> void:
	super()
	visible = false

func initialise(game_ui: GameUI) -> void:
	_game_ui = game_ui
	pass

func _kill_intersecting_insects() -> void:
	var overlapping_areas: Array[Area2D] = _hit_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area.get_parent() is Insect:
			InsectManager.kill(area.get_parent())
