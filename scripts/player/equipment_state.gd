class_name EquipmentState
extends State

var current_equipment: Equipment
@export var _entries: Array[Equipment] = []

func _ready() -> void:
	if _entries.size() <= 0:
		push_error("This weighted spawn entry selector has no entries!")

func set_equipment(equipment: Equipment) -> void:
	current_equipment = equipment
