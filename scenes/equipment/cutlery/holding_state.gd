class_name SpoonHoldingState
extends State

@export var _pickup_area: Area2D
@export var _food_sprite: Sprite2D
@export var _idle_state: State
@export var _feeding_state: SpoonFeedingState

var _current_consumable: ConsumableEntry

func enter() -> void:
	super()

	print(enter_count)
	if enter_count <= 1:
		Globals.said.emit("Feed meeeeeeee!")

func input(event: InputEvent) -> void:
	if !event.is_action_pressed("interact"): return

	var overlapping_areas := _pickup_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area is Target:
			changed_state.emit(_idle_state)
			return

		if area is Mouth:
			_food_sprite.set_texture(null)
			_feeding_state.set_consumable(_current_consumable)
			changed_state.emit(_feeding_state)
			return

func set_consumable(entry: ConsumableEntry) -> void:
	_current_consumable = entry
