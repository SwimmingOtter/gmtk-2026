class_name RuleManager extends Node

static func generate_new_rule(current_rules: Dictionary, max_count_down: int, rule_count: int):
	var a = 0
	var b = 0
	while a == b:
		a = randi() % (max_count_down - 1) + 1
		b = randi() % max_count_down
	
	current_rules[next_rule_id(current_rules, rule_count)] = NumberSwapperModifier.new(a, str(b))
	EventBus.rules_changed.emit(current_rules)
	return current_rules


static func remove_random_rules(current_rules: Dictionary, rule_count: int, rule_lost_per_tower: int) -> Dictionary:
	var idx_to_remove = range(rule_count - 1)
	idx_to_remove.shuffle()
	idx_to_remove = idx_to_remove.slice(0, rule_lost_per_tower)
	for i in idx_to_remove:
		current_rules.erase(i)
	EventBus.rules_changed.emit(current_rules)
	return current_rules


static func next_rule_id(rules: Dictionary, rule_count: int) -> int:
	var id = rule_count - 1
	while rules.has(id):
		id -= 1
	return id


static func reset_rules() -> Dictionary:
	var rules = {Constants.RULE_COUNT - 1: GoldenRule.new()}
	EventBus.rules_changed.emit(rules)
	return rules


static func get_press_rules(rules: Dictionary) -> Array[PressRule]:
	return rules.values().filter(func(rule): return rule is PressRule)


static func get_display_rules(rules: Dictionary) -> Array[DisplayModifier]:
	return rules.values().filter(func(rule): return rule is DisplayModifier)
