extends CanvasLayer

@export var _currency_component: CurrencyComponent

@export var _currency_label: Label

func _ready() -> void:
	_currency_component.balance_changed.connect(_on_currency_changed)
	
func _on_currency_changed(new_currency: float) -> void:
	_currency_label.text = "%d" % new_currency
