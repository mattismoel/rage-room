class_name State
extends Node2D

## Signal sent when wishing to exit this state and change to other state by
## reference.
signal changed_state(to: State)

@export_group("Debug")
@export var debug_enter: bool = false
@export var debug_process: bool = false
@export var debug_physics_process: bool = false
@export var debug_input: bool = false
@export var debug_exit: bool = false

var active: bool = false
var _state_machine: StateMachine

func initialise(state_machine: StateMachine) -> void:
	_state_machine = state_machine
	_state_machine.was_disabled.connect(_on_state_machine_disabled)
	_state_machine.was_enabled.connect(_on_state_machine_enabled)

## Function called upon entering the state. This happens on every state change
## to this state, from another state.
func enter() -> void:
	if !active: return

	if debug_enter:
		print("Entered %s" % name)
	pass

## Function called on every process frame.
func process(delta: float) -> void:
	if !active: return

	if debug_process:
		print("Process on %s" % name)
	pass


## Function called on every physics frame.
func physics_process(delta: float) -> void:
	if !active: return

	if debug_physics_process:
		print("Physics process on %s" % name)
	pass


## Function called on every input.
func input(event: InputEvent) -> void:
	if !active: return

	if debug_input:
		print("Input on %s" % name)
	pass


## Function called upon exiting the state. This happens on every state change
## from this state.
func exit() -> void:
	if debug_exit:
		print("Exit %s" % name)
	pass

## Called whenever the owning state machine was disabled.
func _on_state_machine_disabled() -> void:
	active = false
	pass

## Called whenever the owning state machine was disabled.
func _on_state_machine_enabled() -> void:
	active = true
