extends Node

@export var _game_ui: GameUI

@export var _currency_component: CurrencyComponent
@export var _inventory_component: InventoryComponent
@export var _player_health_component: HealthComponent

func _ready() -> void:
	var inventory_entries := _inventory_component.get_equipment_entries()
	_player_health_component.health_changed.connect(_on_health_changed)

	_game_ui.inventory.set_equipment_entries(inventory_entries)
	_game_ui.inventory.entry_bought.connect(_on_entry_bought)
	_game_ui.inventory.entry_selected.connect(_on_entry_selected)

func _on_entry_bought(entry: EquipmentEntry) -> void:
	var bought := _currency_component.attempt_purchase(entry.cost)
	if !bought: return
	_inventory_component.unlock_entry(entry)

func _on_entry_selected(entry: EquipmentEntry) -> void:
	_inventory_component.equip(entry)
	pass

func _on_health_changed(new_health: float) -> void:
	_game_ui.update_health(new_health)
