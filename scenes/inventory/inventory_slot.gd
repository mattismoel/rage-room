@tool
class_name InventorySlot
extends Control

signal bought
signal pressed

#signal changed_equipment(slot: InventorySlot)

@export var _texture: Texture:
	set(v):
		_texture = v
		if v != null:
			_item_texture.texture = v

@export var _title_label: Label
@export var _item_texture: TextureRect

@export var _animation_player: AnimationPlayer
@export var _select_button: Button
@export var _buy_button: Button

var animation_disabled: bool = false

var entry: EquipmentEntry

func _ready() -> void:
	_buy_button.pressed.connect(bought.emit)
	_select_button.pressed.connect(pressed.emit)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func unlock() -> void:
	_buy_button.hide()

func set_entry(new_entry: EquipmentEntry):
	if new_entry == null: return clear()
	entry = new_entry

	_item_texture.texture = entry.icon_preview
	_item_texture.show()
	_title_label.text = entry.name
	_buy_button.text = "$%d" % entry.cost

	if !entry.is_unlocked:
		_select_button.disabled = true

func clear():
	#_title_label.text = ""
	_item_texture.hide()

func disable():
	_select_button.disabled = true
	_buy_button.disabled = true
	animation_disabled = true

func enable():
	_select_button.disabled = false
	_buy_button.disabled = false
	animation_disabled = false

func _on_mouse_entered() -> void:
	## Pop-up animation
	if animation_disabled: return
	_animation_player.play("focus")

func _on_mouse_exited() -> void:
	## Pop-down animation.
	if animation_disabled: return
	_animation_player.play("unfocus")
