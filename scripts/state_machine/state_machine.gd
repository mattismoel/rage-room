@tool
class_name StateMachine
extends Node2D

signal was_disabled
signal was_enabled

## Emitted when the StateMachine changes from one state to another.
signal state_changed(to: State)

## The initial state, that is entered upon instantiation of the StateMachine.
@export var _initial_state: State

@export_group("Debug")
## Whether or not, the state machine should print information on state change.
@export var _debug_change_state: bool = false


var _states: Array[State] = []
var _current_state: State = null

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	if _initial_state == null:
		push_error("Initial state on StateMachine '%s' is null! Returning early..." % name)
		
	for child in get_children():
		if child is State:
			_states.append(child)
			child.initialise(self)
			child.changed_state.connect(change_state)
	
	change_state(_initial_state)

## Change the StateMachine's state to another.
## If the from and to state are equivelant, nothing happens, and the function
## returns early.
func change_state(to: State) -> void:
	if _current_state == to:
		print_debug("Tried to enter already active state %s. Returning prematurely..." % to.name)
		return

	if _current_state != null:
		_current_state.exit()
		_current_state.active = false
		pass

	var prev_state_name := _current_state.name if _current_state != null else StringName("null")

	_current_state = to
	_current_state.enter()
	_current_state.active = true

	state_changed.emit(to)

	if _debug_change_state:
		print("Changed from %s to %s" % [prev_state_name, to.name])

func request_disable() -> void:
	was_disabled.emit()

func request_enable() -> void:
	was_enabled.emit()

func _process(delta: float) -> void:
	if !_current_state:
		return
	_current_state.process(delta)

func _physics_process(delta: float) -> void:
	if !_current_state:
		return
	_current_state.physics_process(delta)

func _input(event: InputEvent) -> void:
	if !_current_state:
		return
	_current_state.input(event)


