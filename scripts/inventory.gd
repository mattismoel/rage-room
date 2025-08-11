class_name Inventory
extends Node2D

@export var inventory_area: CollisionShape2D
@onready var inventory_rect: Rect2 = inventory_area.get_shape().get_rect()

var _mouse_inside_inventory: bool
signal mouse_entered
signal mouse_left

func _ready() -> void:
	InventoryManager.inventory_changed.connect(_on_inventory_changed)
	print(inventory_rect)
	## Calculates rectangle for detecting when the mouse is in the inventory
	inventory_rect.position += inventory_area.global_position

func _on_inventory_changed() -> void:
	for equipment_entry in InventoryManager.inventory:
		if equipment_entry.unlocked:
			pass

func _process(delta: float) -> void:
	## Detetct if the mouse is entering or leaving the inventory
	var mouse_pos := get_global_mouse_position()
	if inventory_rect.has_point(mouse_pos) and not _mouse_inside_inventory:
		mouse_entered.emit()
		_mouse_inside_inventory = true
	elif not inventory_rect.has_point(mouse_pos) and _mouse_inside_inventory:
		mouse_left.emit()
		_mouse_inside_inventory = false
