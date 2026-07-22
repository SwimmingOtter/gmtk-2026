extends Control

@export var default_start_time: int = 21

@onready var countdown_label: Label = %CountdownLabel
var current_count: int = 21
var press_rules: Array[PressRule] = [GoldenRule.new()]
var display_modifiers: Array[DisplayModifier] = [NumberSwapperModifier.new(2, "9")]

@onready var restart_panel_container: PanelContainer = %RestartPanelContainer
@onready var restart_label: Label = %RestartLabel
@onready var timer: Timer = $Timer

func on_ready() -> void:
	start_game(default_start_time)


func start_game(start_time: int) -> void:
	print("start")
	countdown_label.text = str(start_time)
	current_count = start_time
	timer.start()
	restart_panel_container.visible = false


func _on_timer_timeout() -> void:
	# check if any rule were missed
	_check_rules(false)
		
	current_count -= 1
	if current_count == -1:
		game_lost()
	else:
		countdown_label.text = str(current_count)
		for modifier in display_modifiers:
			countdown_label.text = modifier.apply(countdown_label.text, current_count)


func game_lost(display_text: String = "KO") -> void:
	restart_panel_container.visible = true
	restart_label.text = display_text
	countdown_label.text = display_text
	timer.stop()
	

func game_won(display_text: String = "You did it!") -> void:
	restart_panel_container.visible = true
	restart_label.text = display_text
	countdown_label.text = display_text
	timer.stop()


func _check_rules(pressed: bool) -> void:
	for rule in press_rules:
		if not rule.check(countdown_label.text, current_count, pressed):
			game_lost("Wrong press")


func _on_button_pressed() -> void:
	if current_count == 0:
		print("You did it!")
		game_won()
	else:
		print("Nope!")
		_check_rules(true)

func _on_restart_button_pressed() -> void:
	start_game(default_start_time)
