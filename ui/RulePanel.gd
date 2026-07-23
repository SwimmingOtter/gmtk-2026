class_name RulePanel extends PanelContainer

@onready var rules_container: VBoxContainer = %RulesContainer
var rule_container: PackedScene = preload("uid://dcfx1jmbjjito")

func reset(nb: int) -> void:
	for child in rules_container.get_children():
		child.queue_free()
		
	for i in range(nb):
		var new_rule = rule_container.instantiate()
		rules_container.add_child(new_rule)


func add_rule(rule: Rule, idx: int, rule_count: int) -> void:
	var container = rules_container.get_child(rule_count - idx)
	container.get_child(2).text = rule.description


func remove_rule(idx: int, rule_count: int) -> void:
	var container = rules_container.get_child(rule_count - idx)
	container.get_child(2).text = ""
