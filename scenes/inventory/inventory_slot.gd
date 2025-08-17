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

@export var _select_button: Button
@export var _buy_button: Button


@export_group("Animation")
@export var _hover_height_px: float = 8.0
@export var _hover_trans: Tween.TransitionType 
@export var _hover_ease: Tween.EaseType
@export var _hover_duration: float = 0.1

@onready var _initial_select_button_pos := _select_button.position

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

func enable():
	_select_button.disabled = false
	_buy_button.disabled = false

func _on_mouse_entered() -> void:
	## Pop-up animation
	var tween := create_tween()
	var new_pos := _initial_select_button_pos.y - _hover_height_px

	tween.tween_property(_select_button, "position:y", new_pos, _hover_duration).\
		as_relative()\
		.set_trans(_hover_trans)\
		.set_ease(_hover_ease)

func _on_mouse_exited() -> void:
	var tween := create_tween()
	var new_pos := _initial_select_button_pos.y
	tween.tween_property(_select_button, "position:y", new_pos, _hover_duration)
	tween.set_trans(_hover_trans)
	tween.set_ease(_hover_ease)
	## Pop-down animation.
