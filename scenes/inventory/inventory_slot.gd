@tool
class_name InventorySlot
extends Control

signal bought
signal selected

signal changed_equipment(slot: InventorySlot)

@export var _texture: Texture:
	set(v):
		_texture = v
		if v != null:
			_item_texture.texture = v

@export var _title_label: Label
@export var _item_texture: TextureRect

## Unable to use animation player because of this issue:
## https://github.com/godotengine/godot/issues/104964
@export var _animation_player: AnimationPlayer

@export var _select_button: Button
@export var _buy_button: Button
@export var _inventory_component: InventoryComponent

var _stored_equipment: EquipmentEntry

var debug_float: float = 0

func _ready() -> void:
	_buy_button.pressed.connect(bought.emit)
	_select_button.pressed.connect(selected.emit)

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func initialise(inventory_component: InventoryComponent) -> void:
	_inventory_component = inventory_component

	_inventory_component.unlocked_entry.connect(_on_entry_unlocked)
	_inventory_component.equipped_entry.connect(_on_changed_equipment)
	pass

func set_entry(entry: EquipmentEntry):
	if entry == null: return clear()
	_stored_equipment = entry

	_title_label.text = entry.name
	_buy_button.text = "$%d" % _stored_equipment.cost
	# _item_texture.hide()

	if !entry.is_unlocked:
		_select_button.disabled = true

func get_entry() -> EquipmentEntry:
	return _stored_equipment

func clear():
	_title_label.text = ""
	_stored_equipment = null

func _on_pressed():
	changed_equipment.emit(self)

func _on_entry_unlocked(entry: EquipmentEntry) -> void:
	if entry != _stored_equipment: return

	_buy_button.hide()
	_select_button.disabled = false
	pass

func _on_mouse_entered() -> void:
	## Pop-up animation
	_animation_player.play("focus")
	#position.x = position.x
	pass

func _on_mouse_exited() -> void:
	## Pop-down animation.
	_animation_player.play("unfocus")
	pass

func _on_changed_equipment(entry: EquipmentEntry) -> void:
	# if _stored_equipment != entry:
	# 	_item_texture.show()
	# _item_texture.hide()
	pass
