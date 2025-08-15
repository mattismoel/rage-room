class_name Hand
extends Node2D

@export var _initial_equipment: EquipmentEntry

@export var _max_vertical_arm_extension: float = 100
@export var _struggle_extension: float = 70
@export var _equipment_container: Node2D

@onready var _logistic_constant: float = -log((_max_vertical_arm_extension/\
_struggle_extension)-1)/(_struggle_extension-_max_vertical_arm_extension/2)

func _ready() -> void:
	assert(!is_nan(_logistic_constant), "Invalid values for arm extension")
	set_equipment(_initial_equipment)

func set_equipment(entry: EquipmentEntry) -> void:
	## Queue free any previous equipment.
	for child in _equipment_container.get_children():
		child.queue_free()

	var equipment := entry.scene.instantiate() as Equipment
	_equipment_container.add_child(equipment)
	pass

## Converts regular coordinates to godot coordinates and vice versa
func _coords_convert(in_cords: float) -> float:
	return get_window().content_scale_size.y - in_cords

func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var y_pos = _coords_convert(mouse_pos.y)
	
	## Arm is limited by a logistic function if extended past the struggle bound
	if _coords_convert(mouse_pos.y) > _struggle_extension:		
		var variable = _coords_convert(mouse_pos.y)
		y_pos = _max_vertical_arm_extension/(1+exp(-_logistic_constant\
		*(variable-_max_vertical_arm_extension/2)))
		
	global_position = Vector2(mouse_pos.x, _coords_convert(y_pos))
