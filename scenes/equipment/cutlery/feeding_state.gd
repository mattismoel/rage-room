class_name SpoonFeedingState
extends State

@export var _pickup_area: Area2D
@export var _idle_state: State
@export var _food_sprite: Sprite2D

var _consumable: ConsumableEntry

func enter() -> void:
	super()
	assert(_consumable != null, "There is no consumable set on spoon FeedingState!")

	for area in _pickup_area.get_overlapping_areas():
		if area is not Mouth: continue

		(area as Mouth).feed(_consumable)
		changed_state.emit(_idle_state)
		return

func exit() -> void:
	super()

func set_consumable(consumable: ConsumableEntry) -> void:
	_consumable = consumable
