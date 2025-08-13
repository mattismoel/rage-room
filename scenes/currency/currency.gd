class_name CurrencyComponent
extends Control

var balance: int
@export var balance_label: Label

func _ready() -> void:
	InsectManager.killed.connect(_on_insect_killed)
	
func _on_insect_killed(_insect: Insect) -> void:
	balance += 1
	update_ui()

func update_ui() -> void:
	balance_label.text = str(balance)

## Returns false if the balance is not high enough to complete the purchase
func attempt_purchase(cost: int) -> bool:
	if cost <= balance:
		balance -= cost
		update_ui()
		return true
	return false
