class_name AreaSpawnerComponent
extends SpawnerComponent

var _shape: RectangleShape2D

func _ready() -> void:
	_shape = _find_shape()
	assert(_shape != null, "No spawner shape set.")

## Spawns the input scene randomly within the area defined by its child 
## CollisionShape2D.
func spawn(_pos: Vector2 = Vector2.ZERO) -> void:
	var size := _shape.size

	var spawn_offset := Vector2(\
		randf_range(-size.x / 2, size.x / 2),\
		randf_range(-size.y / 2, size.y / 2)
	)

	var pos := _container.global_position + spawn_offset
	super(pos)


func _find_shape() -> RectangleShape2D:
	for child in get_children(true):
		if child is not CollisionShape2D:
			continue

		if child.shape is not RectangleShape2D:
			continue

		return child.shape

	assert(false, "No CollisionShape defined for AreaSpawnerComponent!")
	return null
