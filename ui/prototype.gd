extends Control

@onready var countdown_label: Label = %CountdownLabel
var current_count_idx: int = 21 # max of base_countdown
var current_countdown: Array[int] = Constants.BASE_COUNTDOWN.duplicate()
var rules: Dictionary = {}
var tower_rounds: int = 0
var retry_count: int = 0

@onready var cheat_panel: PanelContainer = %CheatPanel
@onready var rule_panel: RulePanel = %RulePanel
@onready var restart_panel_container: PanelContainer = %RestartPanelContainer
@onready var restart_label: Label = %RestartLabel
@onready var timer: Timer = $Timer


func _ready() -> void:
	restart_panel_container.visible = true
	
	cheat_panel.visible = Constants.DEBUG_MODE


func start_game() -> void:
	print("start")
	tower_rounds = 0
	_reset_rules()
	restart_panel_container.visible = false
	start_tower_round()


func start_tower_round() -> void:
	tower_rounds += 1
	retry_count = 0
	start_round()


func _reset_rules() -> void:
	rules = RuleManager.reset_rules()


func start_round() -> void:
	print("===== Starting round =====")
	print("Tower round: " + str(tower_rounds) + " / " + str(Constants.TOWER_ROUNDS))
	print("Retry count: " + str(retry_count) + " / " + str(Constants.BASE_RETRY_COUNT))
	print("Rules count: " + str(len(rules)) + " / " + str(Constants.RULE_COUNT))
	
	current_count_idx = Constants.BASE_START_COUNT
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
		for modifier in RuleManager.get_display_rules(rules):
			countdown_label.text = modifier.apply(countdown_label.text, current_count_idx)


func round_lost(display_text: String = "KO") -> void:
	if retry_count < Constants.BASE_RETRY_COUNT:
		retry_count += 1
		start_round()
	else:
		game_lost(display_text)
	

func game_lost(display_text: String = "KO") -> void:
	restart_panel_container.visible = true
	restart_label.text = display_text
	timer.stop()

	
func round_won(display_text: String = "You did it!") -> void:
	if len(rules) < Constants.RULE_COUNT:
		rules = RuleManager.generate_new_rule(rules, Constants.BASE_START_COUNT, Constants.RULE_COUNT)
		start_round()
	else:
		if tower_rounds < Constants.TOWER_ROUNDS:
			rules = RuleManager.remove_random_rules(rules, Constants.RULE_COUNT, Constants.RULE_LOST_PER_TOWER)
			start_tower_round()
		else:
			game_won(display_text)


func game_won(display_text: String = "You did it!") -> void:
	restart_panel_container.visible = true
	restart_label.text = display_text
	timer.stop()


func _check_rules(pressed: bool) -> void:
	for rule in RuleManager.get_press_rules(rules):
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



func _on_win_game_button_pressed() -> void:
	game_won()
	
func _on_win_round_button_pressed() -> void:
	round_won()
	
func _on_lose_game_button_pressed() -> void:
	game_lost()
	
func _on_lose_round_button_pressed() -> void:
	round_lost()
