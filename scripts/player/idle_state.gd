extends State

@export var selection_area: CollisionObject2D

func enter() -> void:
	super()
	visible = true
	#selected_area.area_entered.connect(area_entered)

func input(event) -> void:
	if event.is_action_pressed("interact"):
		print("Mouse pressed at: ", event.position)
		
		# TO-DO: Only smack if hand is not selecting weapon/item from inventory
		change_state_by_name.emit("Smack")

func exit() -> void:
	super()
	visible = false

#func area_entered(area: Area2D) -> void:
#	print(area.name)
