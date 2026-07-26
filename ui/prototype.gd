extends Control

@export var timer_tic_time: float = 0.72


enum STATE {
	NONE,
	ONGOING,
	INTER_ROUND,
	PAUSED
}

var current_count_idx: int = 21 # max of base_countdown
var round_nb: int = 0
var rules: Dictionary = {}
var tower_rounds: int = 0
var retry_count: int = 0
var state: STATE = STATE.NONE


@onready var countdown_label: RichTextLabel = %CountdownLabel
@onready var pause_menu: PauseMenu = %PauseMenu
@onready var cheat_panel: PanelContainer = %CheatPanel
@onready var rule_panel: RulePanel = %RulePanel
@onready var timer: Timer = $Timer
@onready var countdown_animation_player: AnimationPlayer = %CountdownAnimationPlayer
@onready var shader_animation_player: AnimationPlayer = %ShaderAnimationPlayer
@onready var startgame_reveal_animator: AnimationPlayer = %StartgameRevealAnimator
@onready var button: Button = %Button
@onready var start_menu: StartMenu = %StartMenu

func _ready() -> void:
	start_menu.visible = true
	countdown_animation_player.play("ok")
	cheat_panel.visible = Constants.DEBUG_MODE
	state = STATE.NONE
	_set_timer_speed(timer_tic_time)
	%ColorRect.visible = true


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("pause"):
		if timer.is_stopped():
			resume()
		else:
			pause_time()
			pause_menu.visible = true


func resume() -> void:
	pause_menu.visible = false
	start_time()
	state = STATE.ONGOING
	EventBus.game_resumed.emit()


func start_time() -> void:
	timer.start()
	shader_animation_player.play()


func pause_time() -> void:
	timer.stop()
	#shader_animation_player.pause()
	state = STATE.PAUSED
	EventBus.game_paused.emit()


func start_game() -> void:
	EventBus.game_started.emit()
	state = STATE.ONGOING
	print("start")
	startgame_reveal_animator.play("reveal")
	tower_rounds = 0
	round_nb = 0
	_reset_rules()
	await startgame_reveal_animator.animation_finished
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
	
	current_count_idx = CountdownManager.generate_countdown(round_nb)
	countdown_label.text = str(current_count_idx)
	state = STATE.ONGOING
	start_time()

func _on_timer_timeout() -> void:
	if state == STATE.ONGOING:
		# check if any rule were missed
		await _check_rules(false)
		current_count_idx -= 1
		if current_count_idx <= -1:
			inter_round(false)
		else:
			countdown_label.text = str(current_count_idx)
			for modifier in RuleManager.get_display_rules(rules):
				countdown_label.text = modifier.apply(countdown_label.text, current_count_idx)
			
			SoundManager.play_count_down_sound()


func inter_round(go_to_next: bool) -> void:
	pause_time()
	state = STATE.INTER_ROUND
	if go_to_next:
		%TransitionCountdownAnimationPlayer.play("new_rule")
	else:
		%TransitionCountdownAnimationPlayer.play("again")
	await %TransitionCountdownAnimationPlayer.animation_finished


func press_error() -> void:
	pause_time()
	state = STATE.ONGOING
	button.disabled = true
	countdown_animation_player.play("error")
	EventBus.button_pressed_error.emit()

	if retry_count <= Constants.BASE_RETRY_COUNT:
		retry_count += Constants.RETRY_LOST_ON_ERROR
	
	if retry_count > Constants.BASE_RETRY_COUNT:
		game_lost()
		
	await countdown_animation_player.animation_finished
	button.disabled = false
	resume()
	

func game_lost() -> void:
	pause_time()

	EventBus.game_ended.emit()
	EventBus.game_lost.emit()
	
	state = STATE.NONE
	startgame_reveal_animator.play_backwards("reveal")
	await startgame_reveal_animator.animation_finished
	start_menu.visible = true

	
func round_won() -> void:
	EventBus.round_won.emit()
	round_nb += 1
	retry_count -= Constants.RETRY_WON_ON_SUCCES

	countdown_animation_player.play("ok")

	if len(rules) < Constants.RULE_COUNT:
		rules = RuleManager.generate_new_rule(rules, Constants.RULE_COUNT)
		inter_round(true)
	else:
		if tower_rounds < Constants.TOWER_ROUNDS:
			rules = RuleManager.remove_random_rules(rules, Constants.RULE_COUNT, Constants.RULE_LOST_PER_TOWER)
			start_tower_round()
		else:
			game_won()


func game_won() -> void:
	pause_time()
	EventBus.game_ended.emit()
	state = STATE.NONE


func _check_rules(pressed: bool) -> void:
	for rule in RuleManager.get_press_rules(rules):
		if not rule.check(countdown_label.text, current_count_idx, pressed):
			await press_error()


func _on_button_pressed() -> void:
	SoundManager.button_sound()
	if state == STATE.NONE:
		print("Starting Game")
		start_game()
	elif state == STATE.INTER_ROUND:
		start_round()
	elif state == STATE.ONGOING:
		if current_count_idx == 0:
			print("You did it!")
			round_won()
		else:
			print("Nope!")
			_check_rules(true)

func _on_win_game_button_pressed() -> void:
	game_won()
	
func _on_win_round_button_pressed() -> void:
	round_won()
	
	
func _on_lose_game_button_pressed() -> void:
	game_lost()
	
func _on_lose_round_button_pressed() -> void:
	press_error()

func _on_restart_button_pressed() -> void:
	resume()
	start_game()
	

func _on_resume_button_pressed() -> void:
	resume()


func _set_timer_speed(tic_time: float) -> void:
	timer.wait_time = tic_time
	shader_animation_player.speed_scale = tic_time / 2.3


func _on_start_menu_hidden_start_button_pressed() -> void:
	start_menu.visible = false
	SoundManager.button_sound()
	print("Starting Game")
	start_game()
