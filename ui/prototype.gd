extends Control

@export var default_start_idx: int = 21
@export var retry_allowed_by_tower_round: int = 3
@export var nb_of_tower_rounds: int = 4
@export var rules_lost_after_tower_round: int = 6
@export var rule_count: int = 10

const BASE_COUNTDOWN: Array[int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21]

@onready var countdown_label: Label = %CountdownLabel
var current_count_idx: int = 21 # max of base_countdown
var press_rules: Array[PressRule] = [GoldenRule.new()]
var display_modifiers: Array[DisplayModifier] = [NumberSwapperModifier.new(2, "9")]
var current_countdown: Array[int] = BASE_COUNTDOWN.duplicate()
var rules: Array = [GoldenRule.new()]
var tower_rounds: int = 0
var retry_count: int = 0

@onready var rule_panel: RulePanel = %RulePanel
@onready var restart_panel_container: PanelContainer = %RestartPanelContainer
@onready var restart_label: Label = %RestartLabel
@onready var timer: Timer = $Timer


func _ready() -> void:
	restart_panel_container.visible = true


func start_game() -> void:
	print("start")
	tower_rounds = 0
	rule_panel.reset(rule_count)
	_reset_rules()
	restart_panel_container.visible = false
	start_tower_round()


func start_tower_round() -> void:
	tower_rounds += 1
	retry_count = 0
	start_round()


func _reset_rules() -> void:
	rules = [GoldenRule.new()]
	display_modifiers = []
	rule_panel.add_rule(rules[0], 0, rule_count)


func start_round() -> void:
	print("===== Starting round =====")
	print("Tower round: " + str(tower_rounds) + " / " + str(nb_of_tower_rounds))
	print("Retry count: " + str(retry_count) + " / " + str(retry_allowed_by_tower_round))
	print("Rules count: " + str(len(rules)) + " / 10")
	current_count_idx = default_start_idx
	countdown_label.text = str(current_count_idx)
	timer.start()


func _on_timer_timeout() -> void:
	# check if any rule were missed
	_check_rules(false)
		
	current_count_idx -= 1
	if current_count_idx == -1:
		round_lost()
	else:
		countdown_label.text = str(current_count_idx)
		for modifier in display_modifiers:
			countdown_label.text = modifier.apply(countdown_label.text, current_count_idx)


func round_lost(display_text: String = "KO") -> void:
	if retry_count < retry_allowed_by_tower_round:
		retry_count += 1
		start_round()
	else:
		game_lost(display_text)
	

func game_lost(display_text: String = "KO") -> void:
	restart_panel_container.visible = true
	restart_label.text = display_text
	timer.stop()

	
func round_won(display_text: String = "You did it!") -> void:
	if len(rules) < rule_count:
		var new_rule = RuleManager.generate_rule(rules, default_start_idx)
		rules.append(new_rule)
		display_modifiers.append(new_rule)
		rule_panel.add_rule(new_rule, len(rules), rule_count)
		start_round()
	else:
		if tower_rounds < nb_of_tower_rounds:
			var idx_to_remove = range(1, rule_count + 1)
			idx_to_remove.shuffle()
			idx_to_remove = idx_to_remove.slice(0, rules_lost_after_tower_round)
			idx_to_remove.sort()
			idx_to_remove.reverse()
			
			for i in idx_to_remove:
				rule_panel.remove_rule(i, rule_count)
				rules.erase(rules[i - 1])
				display_modifiers.erase(display_modifiers[i - 1])
			start_tower_round()
		else:
			game_won(display_text)


func game_won(display_text: String = "You did it!") -> void:
	restart_panel_container.visible = true
	restart_label.text = display_text
	timer.stop()


func _check_rules(pressed: bool) -> void:
	for rule in press_rules:
		if not rule.check(countdown_label.text, current_count_idx, pressed):
			round_lost("Wrong press")


func _on_button_pressed() -> void:
	if current_count_idx == 0:
		print("You did it!")
		round_won()
	else:
		print("Nope!")
		_check_rules(true)


func _on_restart_button_pressed() -> void:
	start_game()
