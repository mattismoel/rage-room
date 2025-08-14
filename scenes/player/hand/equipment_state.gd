class_name EquipmentState
extends State

@export var _pick_up_state: PickUpState

var _inventory_component: InventoryComponent
var _inventory: Control
var _loaded_equipment: Equipment

func enter() -> void:
	super()
	visible = true

func exit() -> void:
	visible = false

func input(event) -> void:
	if event.is_action_pressed("interact"):
		_loaded_equipment.use(event.position)
	
	## Uncommenting this allows cycling between equipment
	#elif event.is_action_pressed("next_equipment"):
	#	next_in_equipment_cycle(1)
	#elif event.is_action_pressed("prev_equipment"):
	#	next_in_equipment_cycle(-1)

func initialise(inventory_component: InventoryComponent, inventory: Control) -> void:
	_inventory_component = inventory_component
	_inventory = inventory
	_inventory_component.unequipped_entry.connect(_on_entry_unequipped)
	_inventory_component.equipped_entry.connect(_on_entry_equipped)
	pass

func _set_equipment(equipment: EquipmentEntry) -> void:
	if _loaded_equipment != null:
		_loaded_equipment.queue_free()

	## Istantiate new equipment
	_loaded_equipment = equipment.scene.instantiate()
	add_child(_loaded_equipment)
	
	print('"%s" was equipped' % equipment.name)

func _on_entry_equipped(new_entry: EquipmentEntry) -> void:
	_set_equipment(new_entry)

func _on_entry_unequipped(_entry: EquipmentEntry) -> void:
	## Go to back to pick up state when equipment is unequipped
	changed_state.emit(_pick_up_state)

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
		#_set_equipment(_entries[index])
