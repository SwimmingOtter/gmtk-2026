class_name RulePanel extends PanelContainer

@onready var rules_container: VBoxContainer = %RulesContainer
var rule_container: PackedScene = preload("uid://dcfx1jmbjjito")

func reset(nb: int) -> void:
	for child in rules_container.get_children():
		child.queue_free()
		
	for i in range(nb):
		var new_rule = rule_container.instantiate()
		new_rule.get_child(0).text = str(i+1)
		rules_container.add_child(new_rule)


func display(rules: Dictionary, rule_count: int) -> void:
	if rules_container.get_child_count() != rule_count:
		reset(rule_count)

	for i in range(rule_count):
		if rules.has(i):
			add_rule(rules[i], i+1)
		else:
			remove_rule(i+1)

func add_rule(rule: Rule, idx: int) -> void:
	var container = rules_container.get_child(idx)
	container.get_child(2).text = rule.description


func remove_rule(idx: int) -> void:
	var container = rules_container.get_child(idx)
	container.get_child(2).text = ""
