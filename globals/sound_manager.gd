extends Node

@onready var sfx_tic: AudioStreamPlayer = $SFX_Tic
@onready var sfx_la: AudioStreamPlayer = $SFX_La
@onready var sfx_re: AudioStreamPlayer = $SFX_Re
@onready var sfx_re_sharp: AudioStreamPlayer = $SFX_ReSharp
@onready var sfx_do: AudioStreamPlayer = $SFX_Do
@onready var background_music: AudioStreamPlayer = $background_Music
@onready var bcg_moonkey: AudioStreamPlayer = $bcg_moonkey
@onready var blabla: AudioStreamPlayer = $Blabla
@onready var moonkey_first: AudioStreamPlayer = $MoonkeyFirst
@onready var moonkey_second: AudioStreamPlayer = $MoonkeySecond
@onready var wrong: AudioStreamPlayer = $Wrong
@onready var game_over: AudioStreamPlayer = $GameOver

var measure_music: int = 0
var first_bar: bool = true

func _ready() -> void:
	EventBus.game_started.connect(play_background_music)
	EventBus.button_pressed_error.connect(wrongSound)
	EventBus.game_lost.connect(handle_game_lost)
	EventBus.round_won.connect(correctSound)


func handle_game_lost():
	stop_moonkey_music()
	reset_measure_count()
	game_lost()


func reset_measure_count():
	measure_music = 0


func play_background_music():
	if not background_music.playing:
		background_music.play()

func stop_background_music():
	if background_music.playing:
		background_music.stop()
		
func play_moonkey_music():
	if not bcg_moonkey.playing:
		bcg_moonkey.play()

func stop_moonkey_music():
	if bcg_moonkey.playing:
		bcg_moonkey.stop()
		
func moonkeyTalk():
	blabla.play()
	
func correctSound():
	moonkey_second.play()
func wrongSound():
	wrong.play()
	
func game_lost():
	game_over.play()

func button_sound():
	moonkey_first.play()

func play_count_down_sound():
	sfx_tic.play()
	measure_music += 1
	if measure_music == 16:
			measure_music = 0
			
	if measure_music == 9 && not bcg_moonkey.playing:
		play_moonkey_music()
	if first_bar:
		if measure_music != 7:
			measure_music += 1
		else:
			measure_music = 0
			first_bar = false
	else:
		"""if measure_music == 1:
			moonkey_first.play()
		if measure_music == 3:
			moonkey_second.play()
		else: if measure_music == 5:
		else: if measure_music == 7:
		else: if measure_music == 9:"""
		if measure_music == 16:
			measure_music = 0
