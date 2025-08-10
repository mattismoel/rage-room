extends Node

## Emmitted whenever insects are added. It includes the insects that have been 
## added.
signal added(insects: Array[Node2D])

## Emitted whenever an insect is killed. It includes the insect that has been
## killed.
signal killed(insect: Node2D)

## Emitted whenever the insect count changes. It includes the total amount of 
## insects.
signal count_changed(total_count: int)

## Emitted whenever all insects have been killed.
signal all_killed

## Emitted whenever the max insect count has been reached.
signal max_count_reached

## The maximum amount of allowed insects.
const MAX_INSECT_COUNT: int = 500

## Whether or not print statements for added insects should be executed.
var _debug_add_insect: bool = false

## Whether or not print statements for killed insects should be executed.
var _debug_kill_insect: bool = false

var _insects: Array[Node2D] = []


## Adds the given amount of insects to the insect count.
func add(new_insects: Array[Node2D]) -> void:
	if new_insects.is_empty():
		return

	var space_left := MAX_INSECT_COUNT - _insects.size()
	if space_left <= 0:
		return

	var insects_to_add := new_insects
	if new_insects.size() > space_left:
		insects_to_add = new_insects.slice(0, space_left)
		max_count_reached.emit()

	_insects.append_array(insects_to_add)
	count_changed.emit(_insects.size())
	added.emit(insects_to_add)

	if _debug_add_insect:
		print("Added %d insect(s) %s" % [insects_to_add.size(), insects_to_add])


## Kills the input insect and removes it from the manager.
func kill(insect: Node2D) -> void:
	var index: int = _insects.find(insect)
	if index == -1:
		push_warning("Attempted to find and kill %s, but not found in array." % insect.name)
		return

	insect.queue_free()
	killed.emit(insect)

	_insects.remove_at(index)

	var new_count := _insects.size()
	if new_count <= 0:
		all_killed.emit()

	count_changed.emit(new_count)
	if _debug_kill_insect:
		print("Killed insect %s" % insect.name)
