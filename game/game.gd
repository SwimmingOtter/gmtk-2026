extends Node2D

@export var monkey_scene: PackedScene
@export var monkey_count: int = 10
@onready var monkeys: Node2D = $CanvasLayer/Monkeys

func _ready() -> void:
	for monkey in get_tree().get_nodes_in_group("monkey"):
		monkey.free()

	for i in range(monkey_count):
		var monkey = monkey_scene.instantiate()
		monkeys.add_child(monkey)
		var angle: int = randi() % 360 - 180
		var direction = Vector2(cos(angle * PI / 180), sin(angle * PI / 180))
		direction = direction.normalized()
		monkey.position = Vector2(960, 540) + direction * randf_range(200, 400)
