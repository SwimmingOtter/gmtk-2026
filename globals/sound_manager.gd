extends Node
@onready var sfx_tic: AudioStreamPlayer = $SFX_Tic
@onready var sfx_blabla: AudioStreamPlayer = $SFX_Blabla
@onready var button_press: AudioStreamPlayer = $buttonPress
@onready var correct_press: AudioStreamPlayer = $correctPress
@onready var wrong_press: AudioStreamPlayer = $wrongPress
@onready var game_over: AudioStreamPlayer = $gameOver
@onready var waiting_clock: AudioStreamPlayer = $waitingClock
@onready var sfx_first_tick: AudioStreamPlayer = $SFX_FirstTick
@onready var sfx_strong_tick: AudioStreamPlayer = $SFX_StrongTick
@onready var sfx_round_start: AudioStreamPlayer = $SFX_RoundStart
@onready var sfx_strong_correct: AudioStreamPlayer = $SFX_StrongCorrect
@onready var moonkey_hype: AudioStreamPlayer = $moonkeyHype
@onready var moonkey_boo: AudioStreamPlayer = $moonkeyBoo
@onready var victory_song: AudioStreamPlayer = $Victory_Song
@onready var moonkey_theme: AudioStreamPlayer = $MoonkeyTheme



var measure_music: int = 0
var first_bar: bool = true
var nb_rules: int = 1
var nextIsStart: bool = true
var seriousLevel : int = 10

func _ready() -> void:
	EventBus.button_pressed_error.connect(wrongSound)
	EventBus.game_lost.connect(handle_game_lost)
	EventBus.round_won.connect(correctSound)
	EventBus.game_started.connect(stop_sounds_start)
	EventBus.moonkey_talked.connect(moonkeyTalk)
	EventBus.rules_changed.connect(_new_rule)
	EventBus.game_won.connect(victory_music)
	EventBus.timer_paused.connect(setNextIsStart)
	EventBus.game_restarted.connect(stopVictoryMusic)
	
func _new_rule(rules: Dictionary) -> void:
	nb_rules += 1

func stopVictoryMusic():
	if victory_song.playing:
		victory_song.stop()

func setNextIsStart():
	nextIsStart = true
	
func playFirstTick():
	sfx_first_tick.play()
	
func play_game_intro():
	moonkey_theme.play()
	
func handle_game_lost():
	reset_measure_count()
	start_clock()
	game_lost()

func victory_music():
	victory_song.play()
	

func reset_measure_count():
	measure_music = 0

func start_clock() -> void:
	waiting_clock.play()
	
func stop_sounds_start():
	if waiting_clock.playing:
		waiting_clock.stop()
	if moonkey_theme.playing:
		moonkey_theme.stop()
	sfx_round_start.play()
	
		
func moonkeyTalk():
	sfx_blabla.play()

func moonkeyHype():
	moonkey_hype.play()
	
func moonkeyBoo():
	moonkey_boo.play()
	
	
func correctSound():
	if button_press.playing:
		button_press.stop()
	if nb_rules <= seriousLevel:
		correct_press.play()
	else:
		sfx_strong_correct.play()
	
func wrongSound():
	if button_press.playing:
		button_press.stop()
	wrong_press.play()
	
func game_lost():
	if wrong_press.playing:
		wrong_press.stop()
	game_over.play()

func button_sound():
	if !nextIsStart:
		button_press.play()
	else:
		sfx_round_start.play()
		nextIsStart = false

func play_count_down_sound():
	measure_music += 1	
	if measure_music >= 1:
		if nb_rules <= seriousLevel:
			sfx_tic.play()
		else:
			sfx_strong_tick.play()
	
