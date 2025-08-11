extends ProgressBar

@export var _health_component: HealthComponent

func _ready() -> void:
	max_value = _health_component.max_health
	value = _health_component.health

	_health_component.health_changed.connect(_on_health_changed)

func _on_health_changed(health: float) -> void:
	value = health
	pass
