class_name GameUI
extends Control

signal inventory_entry_entered(entry: EquipmentEntry)
signal inventory_entry_exited(entry: EquipmentEntry)

@export var cursor: Cursor
@export var inventory: InventoryUI

@export var _player_health_component: HealthComponent

@export var _currency_component: CurrencyComponent
@export var _currency_label: Label
@export var _health_bar: HealthBar

func _ready() -> void:
	_currency_component.balance_changed.connect(_on_currency_changed)

	_health_bar.max_value = _player_health_component.max_health
	_health_bar.value = _player_health_component.initial_health

	inventory.entry_entered.connect(inventory_entry_entered.emit)
	inventory.entry_exited.connect(inventory_entry_exited.emit)

func _on_currency_changed(new_currency: float) -> void:
	_currency_label.text = "%d" % new_currency

func update_health(new_health: float) -> void:
	_health_bar.set_health(new_health)
