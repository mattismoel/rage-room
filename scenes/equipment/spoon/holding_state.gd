class_name SpoonHoldingState
extends State

@export var _equipment: Equipment
@export var _pickup_area: Area2D
@export var _food_sprite: Sprite2D
@export var _idle_state: State
@export var _feeding_state: SpoonFeedingState

var _current_consumable: ConsumableEntry

func _ready() -> void:
	_food_sprite.hide()

func enter() -> void:
	super()
	_equipment.used.connect(_on_equipment_used)

func exit() -> void:
	super()
	_equipment.used.disconnect(_on_equipment_used)

func set_consumable(entry: ConsumableEntry) -> void:
	_current_consumable = entry
	_food_sprite.show()

func _on_equipment_used() -> void:
	var overlapping_areas := _pickup_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area is Target:
			_food_sprite.hide()
			changed_state.emit(_idle_state)
			return

		if area is Mouth:
			_feeding_state.set_consumable(_current_consumable)
			changed_state.emit(_feeding_state)
			return
