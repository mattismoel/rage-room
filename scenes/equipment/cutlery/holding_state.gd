class_name SpoonHoldingState
extends State

const FEED_LINES: Array[String] = [
	"Feed me!",
	"That looks yummy!",
	"I could eat a horse!",
	"Did i just hear my stomach growl?",
]

@export var _pickup_area: Area2D
@export var _food_sprite: Sprite2D
@export var _idle_state: State
@export var _feeding_state: SpoonFeedingState

@export var _sound_player: AudioStreamPlayer2D
@export var _feed_line_probability: float = 0.25

var _current_consumable: ConsumableEntry

func enter() -> void:
	super()

	if randf() <= _feed_line_probability:
		var line: String = FEED_LINES.pick_random()
		Globals.said.emit(line)

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
			_sound_player.play()
			changed_state.emit(_feeding_state)
			return

func set_consumable(entry: ConsumableEntry) -> void:
	_current_consumable = entry
