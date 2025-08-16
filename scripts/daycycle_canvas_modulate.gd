@tool
extends CanvasModulate

@export var _gradient: Gradient
@export var _daycycle_component: DaycycleComponent

func _ready() -> void:
	_daycycle_component.intensity_changed.connect(func(v): 
		color = _gradient.sample(v)
	)

func _process(delta: float) -> void:
	color = _gradient.sample(_daycycle_component.intensity)
