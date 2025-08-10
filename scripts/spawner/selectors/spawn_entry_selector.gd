class_name SpawnEntrySelector
extends Node

## Gets an entry from the selection.
##
## This method must be implemented by descendants.
func get_entry() -> SpawnEntry:
	push_error("The get_entry() method must be implemented.")
	return null
