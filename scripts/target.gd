class_name Target
extends Area2D 

@export var weight: float = 1.0
@export var _damage_per_insect: float = 1.0

@export_group("References")
@export var _health_component: HealthComponent
@export var _timer: Timer

var _contained_insects: Array[Insect] = []

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	_timer.timeout.connect(_on_timer_timeout)

func _on_area_entered(area: Area2D) -> void:
	var parent := area.get_parent()

	if parent is Insect:
		_contained_insects.append(parent)
		parent.killed.connect(_on_insect_killed)
		print("HAS ", _contained_insects.size())
		return


func _on_timer_timeout() -> void:
	if _contained_insects.size() <= 0: 
		return
	var total_damage := _contained_insects.size() * _damage_per_insect
	_health_component.take_damage(total_damage)


func _on_insect_killed(insect: Insect) -> void:
	var index := _contained_insects.find(insect)
	assert(index != -1, "The killed insect could not be found in the targets contained insects.")
	_contained_insects.remove_at(index)
