extends State

@export var _allowed_consumables: Array[ConsumableEntry] = []
@export var _pickup_area: Area2D
@export var _holding_state: SpoonHoldingState

func input(event: InputEvent) -> void:
	super(event)
	if !event.is_action_pressed("interact"): return

	for area in _pickup_area.get_overlapping_areas():
		if area is not Target: continue
		var consumable := (area as Target).consumable
		if !_is_allowed_consumable(consumable): continue

		_holding_state.set_consumable(consumable)
		changed_state.emit(_holding_state)

## Returns whether or not the consumable is allowed to be picked up by the 
## spoon.
func _is_allowed_consumable(consumable: ConsumableEntry) -> bool:
	return _allowed_consumables.has(consumable)
