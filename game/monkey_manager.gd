class_name MonkeyManager extends Node2D

@export var monkey_scene: PackedScene
@export var monkey_count: int = 30

func _ready() -> void:
	EventBus.game_started.connect(spawn_monkeys)
	EventBus.game_lost.connect(despawn_monkeys)
	despawn_monkeys()
	
func despawn_monkeys():
	for monkey in get_tree().get_nodes_in_group("monkey"):
		monkey.free()
	
func spawn_monkeys():
	for i in range(monkey_count):
		var monkey = monkey_scene.instantiate()
		self.add_child(monkey)
		monkey.add_to_group("monkey")
		
		var angle: int = randi() % 110
		if angle > 55:
			angle += 50
		var direction = Vector2(cos(angle * PI / 180), sin(angle * PI / 180))
		direction = direction.normalized()
		monkey.position = Vector2(960, 540) + direction * randf_range(0, 500)
