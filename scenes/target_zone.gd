class_name TargetZone
extends Area2D

func find_target() -> Target:
	var _targets: Array[Target] = []

	for area in get_overlapping_areas():
		if area is Target:
			if area.is_empty(): continue
			_targets.push_back(area)


	if _targets.size() <= 0:
		for area in get_overlapping_areas():
			if area is Target:
				_targets.push_back(area)


	# assert(_targets.size() > 0, "No overlapping targets")

	var best_target: Target = _targets[0]
	var lowest_score: float = _calculate_score(_targets[0])

	for target in _targets:
		var score = _calculate_score(target)

		if score < lowest_score:
			best_target = target
			lowest_score = score

	return best_target


func _calculate_score(target: Target) -> float:
	var distance := global_position.distance_to(target.global_position)
	return distance * (1.0 / target.weight)
