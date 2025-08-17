extends State

@export var _allowed_consumables: Array[ConsumableEntry] = []
@export var _pickup_area: Area2D
@export var _holding_state: SpoonHoldingState
@export var _sprite: Sprite2D

func input(event: InputEvent) -> void:
	super(event)

	if !event.is_action_pressed("interact"): return

	for area in _pickup_area.get_overlapping_areas():
		if area is not Target: 
			continue

		var target := area as Target
		var consumable := (area as Target).consumable

		if target.is_empty(): 
			Globals.said.emit("Ah crap. They ate it all!")
			continue

		if !_is_allowed_consumable(consumable): return

		_sprite.set_texture(consumable.food_sprite)
		
		
		_holding_state.set_consumable(consumable)
		changed_state.emit(_holding_state)

## Returns whether or not the consumable is allowed to be picked up by the 
## spoon.
func _is_allowed_consumable(consumable: ConsumableEntry) -> bool:
	var allowed := _allowed_consumables.has(consumable)
	return allowed
