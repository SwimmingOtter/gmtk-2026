extends Control

@export var layers: Array[Control]
@export var strengths: Array[float]
@export var smoothing := 8.0

var start_positions: Array[Vector2] = []

func _ready():
	for layer in layers:
		start_positions.append(layer.position)

func _process(delta):
	var viewport_size = get_viewport_rect().size
	var mouse = get_viewport().get_mouse_position()

	# Mouse position in range [-1, 1]
	var normalized = (mouse / viewport_size) * 2.0 - Vector2.ONE

	for i in range(min(layers.size(), strengths.size())):
		var target = start_positions[i] - normalized * strengths[i]
		layers[i].position = layers[i].position.lerp(target, smoothing * delta)
