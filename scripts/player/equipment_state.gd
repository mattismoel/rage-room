class_name EquipmentState
extends State

@export var idle_state: IdleState
@export var pick_up_state: PickUpState

@export var _entries: Array[EquipmentEntry] = []
@onready var current_equipment_entry: EquipmentEntry = _entries[0]
var loaded_equipment: Equipment

func enter() -> void:
	super()
	visible = true
		
	if _entries.size() <= 0:
		push_error("This weighted spawn entry selector has no entries!")

func exit() -> void:
	remove_child(loaded_equipment)
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
	current_equipment_entry = equipment
	loaded_equipment = current_equipment_entry.scene.instantiate()
	add_child(loaded_equipment)
	
	print("Set equipment to %s" % current_equipment_entry.name)

func next_in_equipment_cycle(steps: int) -> void:
	var index := _entries.find(current_equipment_entry) + steps
	
	## Restart the loop when last equipment entry is reached
	index = index - _entries.size() if index >= _entries.size() else index
	set_equipment_from_index(index)

func set_equipment_from_index(index: int) -> void:
	# Check that requested equipment index is valid
	if index < _entries.size():
		set_equipment(_entries[index])
