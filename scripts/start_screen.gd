extends Control

@export_file("*.tscn") var _game_file
@export var _start_button: Button

func _ready() -> void:
	_start_button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(_game_file)
	pass

