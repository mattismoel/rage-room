class_name EquipmentState
extends State

@export var idle_state: IdleState
@export var pick_up_state: PickUpState

var loaded_equipment: Equipment

func enter() -> void:
	super()
	visible = true
	InventoryManager.entry_unequipped.connect(_on_entry_unequipped)

func exit() -> void:
	loaded_equipment.queue_free()
	InventoryManager.entry_unequipped.disconnect(_on_entry_unequipped)
	visible = false

func input(event) -> void:
	if event.is_action_pressed("interact"):
		loaded_equipment.use(event.position)
	
	## Uncommenting this allows cycling between equipment
	#elif event.is_action_pressed("next_equipment"):
	#	next_in_equipment_cycle(1)
	#elif event.is_action_pressed("prev_equipment"):
	#	next_in_equipment_cycle(-1)

func set_equipment(equipment: EquipmentEntry) -> void:
	if loaded_equipment != null:
		loaded_equipment.queue_free()

	## Istantiate new equipment
	loaded_equipment = equipment.scene.instantiate()
	add_child(loaded_equipment)
	
	print('"%s" was equipped' % equipment.name)

func _on_entry_unequipped() -> void:
	## Go to back to pick up state when equipment is unequipped
	change_state.emit(pick_up_state)

#func next_in_equipment_cycle(steps: int) -> void:
	#var index := _entries.find(current_equipment_entry) + steps
	#
	### Restart the loop when last equipment entry is reached
	#index = index - _entries.size() if index >= _entries.size() else index
	#set_equipment_from_index(index)
#
#func set_equipment_from_index(index: int) -> void:
	## Check that requested equipment index is valid
	#if index < _entries.size():
		#set_equipment(_entries[index])
