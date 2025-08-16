@tool
class_name RateTimer
extends Timer

@export var rate: float = 1.0:
	set(v):
		wait_time = 1.0 / v
		rate = v
