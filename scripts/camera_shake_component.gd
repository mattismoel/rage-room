class_name ShakeCamera
extends Camera2D

@export var _decay: float = 0.8
@export var _max_offset: Vector2 = Vector2(100, 75)
@export var _follow_node: Node2D

var _trauma: float = 0.0
var _trauma_power: int = 2

func _ready() -> void:
	randomize()
	Globals.camera = self

func _process(delta: float) -> void:
	if _follow_node:
		global_position = _follow_node.global_position

	if _trauma:
		_trauma = max(_trauma - _decay * delta, 0.0)
		shake()

func shake() -> void:
	var amount := pow(_trauma, _trauma_power)
	offset.x = _max_offset.x * amount * randf_range(-1.0, 1.0)
	offset.y = _max_offset.y * amount * randf_range(-1.0, 1.0)

func add_trauma(amount: float) -> void:
	_trauma = min(_trauma + amount, 1.0)
