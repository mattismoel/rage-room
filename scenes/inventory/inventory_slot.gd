class_name InventorySlot
extends Control

signal bought
signal pressed

#signal changed_equipment(slot: InventorySlot)

@export var _title_label: Label
@export var _item_texture: TextureRect

@export var _select_button: Button
@export var _equipment_sprite: TextureRect
@export var _buy_button: Button

@export_group("Animation")
@export var _hover_height_px: float = 0
@export var _hover_trans: Tween.TransitionType 
@export var _hover_ease: Tween.EaseType
@export var _hover_duration: float = 0.1

@onready var _initial_sprite_position := _equipment_sprite.position

var entry: EquipmentEntry
var _hover_animation_disabled: bool = true

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
	_hover_animation_disabled = true

func enable():
	_select_button.disabled = false
	_hover_animation_disabled = false

func _on_mouse_entered() -> void:
	## Fade-in animation
	var fade_in_tween := create_tween()

	fade_in_tween.tween_property(_title_label, "modulate:a", 1, _hover_duration).\
		as_relative()\
		.set_trans(_hover_trans)\
		.set_ease(_hover_ease)
		
	if _hover_animation_disabled: return
	## Pop-up animation
	var tween := create_tween()
	var new_pos := _initial_sprite_position.y - _hover_height_px

	tween.tween_property(_equipment_sprite, "position:y", new_pos, _hover_duration).\
		as_relative()\
		.set_trans(_hover_trans)\
		.set_ease(_hover_ease)

func _on_mouse_exited() -> void:
	## Fade-out animation
	var fade_out_tween := create_tween()

	fade_out_tween.tween_property(_title_label, "modulate:a", 0, _hover_duration)\
		.set_trans(_hover_trans)\
		.set_ease(_hover_ease)
	
	## Pop-down animation.
	if _hover_animation_disabled: return
	var tween := create_tween()
	var new_pos := _initial_sprite_position.y
	tween.tween_property(_equipment_sprite, "position:y", new_pos, _hover_duration)
	tween.set_trans(_hover_trans)
	tween.set_ease(_hover_ease)
