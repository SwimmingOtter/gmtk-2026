extends Node
@onready var sfx_tic: AudioStreamPlayer = $SFX_Tic
@onready var bcg_moonkey: AudioStreamPlayer = $bcg_moonkey
@onready var sfx_blabla: AudioStreamPlayer = $SFX_Blabla
@onready var button_press: AudioStreamPlayer = $buttonPress
@onready var correct_press: AudioStreamPlayer = $correctPress
@onready var wrong_press: AudioStreamPlayer = $wrongPress
@onready var game_over: AudioStreamPlayer = $gameOver
@onready var waiting_clock: AudioStreamPlayer = $waitingClock
@onready var intro_chords: AudioStreamPlayer = $introChords
@onready var clockno_intro: AudioStreamPlayer = $ClocknoIntro
@onready var sfx_first_tick: AudioStreamPlayer = $SFX_FirstTick



var measure_music: int = 0
var first_bar: bool = true

func _ready() -> void:
	"""EventBus.game_started.connect(play_background_music)"""
	EventBus.button_pressed_error.connect(wrongSound)
	EventBus.game_lost.connect(handle_game_lost)
	EventBus.round_won.connect(correctSound)
	EventBus.game_started.connect(stop_sounds_start)
	EventBus.monkey_talked.connect(moonkeyTalk)

func startClockNoIntro():
	clockno_intro.play()
	
func play_game_intro():
	intro_chords.connect("finished", Callable(self, "startClockNoIntro"))
	intro_chords.play()
	
func handle_game_lost():
	stop_moonkey_music()
	reset_measure_count()
	start_clock()
	game_lost()
	

func reset_measure_count():
	measure_music = 0

func start_clock() -> void:
	waiting_clock.play()
	
func stop_sounds_start():
	if waiting_clock.playing:
		waiting_clock.stop()
	if intro_chords.playing:
		intro_chords.stop()
	if clockno_intro.playing:
		clockno_intro.stop()
	sfx_first_tick.play()
	
"""func play_background_music():
	if not background_music.playing:
		background_music.play()

func stop_background_music():
	if background_music.playing:
		background_music.stop()"""
		
func play_moonkey_music():
	if not bcg_moonkey.playing:
		bcg_moonkey.play()

func stop_moonkey_music():
	if bcg_moonkey.playing:
		bcg_moonkey.stop()
		
func moonkeyTalk():
	sfx_blabla.play()
	
func correctSound():
	"""if button_press.playing:
		button_press.stop()"""
	correct_press.play()
func wrongSound():
	if button_press.playing:
		button_press.stop()
	wrong_press.play()
	
func game_lost():
	if wrong_press.playing:
		wrong_press.stop()
	game_over.play()

func button_sound():
	button_press.play()

func play_count_down_sound():
	sfx_tic.play()
	measure_music += 1	
	"""if measure_music == 9 && not bcg_moonkey.playing:
		play_moonkey_music()"""
