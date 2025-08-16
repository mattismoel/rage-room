class_name HealthComponent
extends Node

## Emitted whenever the health depletes (reaches zero).
signal health_depleted

## Emitted whenever the health changes. It includes the current health, as a 
## result of the change.
signal health_changed(current_health: float)

## Emitted whenever max health is reached, as a result of healing. It includes
## the max health.
signal max_health_reached(max_health: float)

## The amount of health upon initialisation.
@export var initial_health: float = 100

## The max amount of health.
@export var max_health: float = 100

## The current health.
@onready var health: float = initial_health

func _ready() -> void:
	health_changed.emit(health)

## Takes the input amount of damage.
##
## If wishing to add health, use heal() function.
func take_damage(amount: float) -> void:
	## Make sure amount is positive.
	assert(amount > 0, "Amount of damage must be positive.")

	health -= amount

	health = max(0, health)
	if health <= 0:
		health_depleted.emit()

	health_changed.emit(health)


## Heals the input amount of health.
func heal(amount: float) -> void:
	## Make sure amount is positive.
	assert(amount > 0, "Amount of health must be positive.")

	health += amount

	health = min(health, max_health)
	if health >= max_health:
		max_health_reached.emit(max_health)

	health_changed.emit(health)


## Returns the ratio of current health with respect to the max health.
##
## Examples: 
## 50 / 100 -> 0.50 (50% health)
## 75 / 250 -> 0.30 (30% health)
func calculate_health_ratio() -> float:
	return health / max_health
