class_name RulePanel extends PanelContainer

@onready var rules_container: VBoxContainer = %RulesContainer
var rule_container: PackedScene = preload("uid://dcfx1jmbjjito")

func _ready() -> void:
	EventBus.rules_changed.connect(_on_rules_changed)

func reset(nb: int) -> void:
	for child in rules_container.get_children():
		child.free() # instead of queue_free to avoid waiting for the next frame
		
	for i in range(nb):
		var new_rule = rule_container.instantiate()
		new_rule.get_child(0).text = str(i + 1)
		rules_container.add_child(new_rule)


func display(rules: Dictionary, rule_count: int) -> void:
	if rules_container.get_child_count() != rule_count:
		reset(rule_count)

	for i in range(rule_count):
		if rules.has(i):
			add_rule(rules[i], i)
		else:
			remove_rule(i)

func add_rule(rule: Rule, idx: int) -> void:
	var container = rules_container.get_child(idx)
	container.get_child(2).text = rule.description


func remove_rule(idx: int) -> void:
	var container = rules_container.get_child(idx)
	container.get_child(2).text = ""


func _on_rules_changed(rules: Dictionary) -> void:
	display(rules, Constants.RULE_COUNT)
