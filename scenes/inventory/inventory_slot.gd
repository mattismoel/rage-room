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

var entry: EquipmentEntry

var debug_float: float = 0

func _ready() -> void:
	_buy_button.pressed.connect(bought.emit)
	_select_button.pressed.connect(selected.emit)

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func unlock() -> void:
	_buy_button.hide()
	_select_button.disabled = false

func set_entry(new_entry: EquipmentEntry):
	if entry == null: return clear()
	entry = new_entry

	_title_label.text = entry.name
	_buy_button.text = "$%d" % entry.cost
	# _item_texture.hide()

	if !entry.is_unlocked:
		_select_button.disabled = true

func clear():
	_title_label.text = ""
	entry = null

func _on_pressed():
	changed_equipment.emit(self)

func _on_mouse_entered() -> void:
	print("OVER")
	## Pop-up animation
	_animation_player.play("focus")
	#position.x = position.x
	pass

func _on_mouse_exited() -> void:
	print("OUT")
	## Pop-down animation.
	_animation_player.play("unfocus")
	pass
