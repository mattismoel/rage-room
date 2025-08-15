extends Node

@export var _game_ui: GameUI
@export var _hand: Hand

@export var _currency_component: CurrencyComponent
@export var _inventory_component: InventoryComponent
@export var _player_health_component: HealthComponent

func _ready() -> void:
	var inventory_entries := _inventory_component.get_equipment_entries()
	_player_health_component.health_changed.connect(_on_health_changed)

	_game_ui.inventory.set_equipment_entries(inventory_entries)
	_game_ui.inventory.entry_bought.connect(_on_entry_bought)
	_game_ui.inventory.entry_selected.connect(_on_entry_selected)

	_game_ui.inventory.entry_entered.connect(_on_entry_entered)
	_game_ui.inventory.entry_exited.connect(_on_entry_exited)
	_game_ui.cursor.hide()

func _on_entry_bought(entry: EquipmentEntry) -> void:
	var bought := _currency_component.attempt_purchase(entry.cost)
	if !bought: return
	_inventory_component.unlock_entry(entry)
	_game_ui.inventory.unlock_slot(entry)

func _on_entry_selected(entry: EquipmentEntry) -> void:
	if _inventory_component.current_equipment() != null:
		_inventory_component.unequip()
		_game_ui.inventory.populate_slot(entry)
	else:
		_inventory_component.equip(entry)
		_game_ui.inventory.vacate_slot(entry)

func _on_health_changed(new_health: float) -> void:
	_game_ui.update_health(new_health)

func _on_entry_entered(_entry: EquipmentEntry) -> void:
	_game_ui.cursor.show()
	_hand.hide()

func _on_entry_exited(_entry: EquipmentEntry) -> void:
	_game_ui.cursor.hide()
	_hand.show()
