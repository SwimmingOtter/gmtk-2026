class_name RuleManager extends Node

static func generate_rule(current_rules: Array, max_count_down: int = 21):
	var a = 0
	var b = 0
	while a == b:
		a = randi() % (max_count_down - 1) + 1
		b = randi() % max_count_down
	return NumberSwapperModifier.new(a, str(b))
