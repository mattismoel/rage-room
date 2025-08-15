class_name IdleState
extends State

@export var _pick_up_state: PickUpState
@export var _smack_state: SmackState
@export var _animation_player: AnimationPlayer

var _game_ui: GameUI

func enter() -> void:
	super()
	visible = true
	_animation_player.play("idle")
	if _game_ui != null: initialize(_game_ui)
	# game_ui.inventory.entry_entered.connect(_on_entry_entered)

func initialize(game_ui: GameUI) -> void:
	print("OIIIII", game_ui.inventory)
	# _inventory = inventory
	_game_ui = game_ui
	_game_ui.inventory_entry_entered.connect(_on_entry_entered)

func input(event) -> void:
	if event.is_action_pressed("interact"):
		changed_state.emit(_smack_state)

func exit() -> void:
	super()
	visible = false
	_game_ui.inventory_entry_entered.disconnect(_on_entry_entered)

func _on_entry_entered(_entry: EquipmentEntry) -> void:
	print("OI")
	changed_state.emit(_pick_up_state)
