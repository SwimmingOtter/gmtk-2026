extends Node2D


func _ready() -> void:
	for monkey in get_tree().get_nodes_in_group("monkey"):
		if randf() < 0.5:
			monkey.position = Vector2(randf_range(200, 1700), randf_range(100, 360))
		else:
			monkey.position = Vector2(randf_range(200, 1700), randf_range(700, 900))
