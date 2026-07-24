extends Node

@onready var sfx_tic: AudioStreamPlayer = $SFX_Tic
@onready var sfx_la: AudioStreamPlayer = $SFX_La
@onready var sfx_re: AudioStreamPlayer = $SFX_Re
@onready var sfx_re_sharp: AudioStreamPlayer = $SFX_ReSharp
@onready var sfx_do: AudioStreamPlayer = $SFX_Do
@onready var background_music: AudioStreamPlayer = $background_Music

var measure_music: int = 0
var first_bar: bool = true

func play_background_music():
	if not background_music.playing:
		background_music.play()

func stop_background_music():
	if background_music.playing:
		background_music.stop()

func play_count_down_sound():
	sfx_tic.play()
	if first_bar:
		if measure_music != 7:
			measure_music += 1
		else:
			measure_music = 0
			first_bar = false
	else:
		measure_music += 1
		if measure_music == 1:
			sfx_la.play()
		else: if measure_music == 5:
			sfx_do.play()
		else: if measure_music == 7:
			sfx_re_sharp.play()
		else: if measure_music == 9:
			sfx_re.play()
		if measure_music == 16:
			measure_music = 0
