extends StateMachine

# Emitted when user initiates a smack
signal smack(pos: Vector2)

func _ready() -> void:
	super()
	# Print the size of the viewport.
	print("Viewport Resolution is: ", get_viewport().get_visible_rect().size)

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	super(delta)
