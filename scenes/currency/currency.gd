extends Control

var balance: int
@export var balance_label: Label

func _ready() -> void:
	InsectManager.killed.connect(_on_insect_killed)
	
func _on_insect_killed(_insect: Insect) -> void:
	balance += 1
	balance_label.text = str(balance)
