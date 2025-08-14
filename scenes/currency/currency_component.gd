class_name CurrencyComponent
extends Node

signal balance_changed(new_currency)

@export var _initial_balance: int = 0

@onready var balance: int = _initial_balance

func _ready() -> void:
	InsectManager.killed.connect(_on_insect_killed)

	if balance > 0:
		balance_changed.emit(balance)

## Returns false if the balance is not high enough to complete the purchase.
func attempt_purchase(cost: int) -> bool:
	if cost >= balance: return false

	balance -= cost
	balance_changed.emit(balance)
	return true

func _on_insect_killed(_insect: Insect) -> void:
	balance += 1
	balance_changed.emit(balance)
