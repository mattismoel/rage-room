@tool
class_name StateMachine
extends Node2D

## Emitted when the StateMachine changes from one state to another.
signal state_changed(to: State)

## The initial state, that is entered upon instantiation of the StateMachine.
@export var initial_state: State

@export_group("Debug")
## Whether or not, the state machine should print information on state change.
@export var debug_change_state: bool = false


var states: Array[State] = []
var _current_state: State = null


func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	if initial_state == null:
		push_error("Initial state on StateMachine '%s' is null! Returning early..." % name)
		
	for child in get_children():
		if child is State:
			states.append(child)
			child.change_state.connect(change_state)
			child.change_state_by_name.connect(change_state_by_name)

	change_state(initial_state)

## Change the StateMachine's state to another.
## If the from and to state are equivelant, nothing happens, and the function
## returns early.
##
## If desired, the state can also be changed with the 'change_state_by_name'
## function, for changing by state name instead of direct reference.
func change_state(to: State) -> void:
	if _current_state == to:
		print_debug("Tried to enter already active state %s. Returning prematurely..." % to.name)
		return

	if _current_state != null:
		_current_state.exit()
		_current_state.active = false
		pass

	var prev_state_name: String = _current_state.name if _current_state else "null"

	_current_state = to
	_current_state.enter()
	_current_state.active = true

	state_changed.emit(to)

	if debug_change_state:
		print("Changed from %s to %s" % [prev_state_name, to.name])


## Changes the StateMachine's state by name. If the state does not exist,
## noting happens.
func change_state_by_name(to_name: String) -> void:
	var to_state := state_by_name(to_name)

	if to_state == null:
		return
	change_state(to_state)

## Searches for a state with a given name. If found, the state is returned,
## else 'null' is returned.
func state_by_name(state_name: String) -> State:
	for state in states:
		if state.name.to_lower() == state_name.to_lower():
			return state
	return null


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
