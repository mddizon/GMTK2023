extends Node2D

@onready var music: AudioStreamPlayer = $Music
@onready var soundEffects: AudioStreamPlayer = $Sound

var startMenuMusic = preload("res://assets/Audio/Music/Rising Tide (faster).mp3")
var gameMusic = preload("res://assets/Audio/Music/Voltaic.mp3")
var winMusic = preload("res://assets/Audio/Music/esm_8_bit_game_over_1_arcade_80s_simple_alert_notification_game.mp3")
var loseMusic = preload("res://assets/Audio/Music/esm_8_bit_game_over_2_arcade_80s_simple_alert_notification_game.mp3")

func _ready():
	pass

func playStartMusic():
	music.stop()
	_playMusic(startMenuMusic)

func playGameMusic():
	music.stop()
	_playMusic(gameMusic)

func playWinMusic():
	music.stop()
	_playMusic(winMusic)

func playLoseMusic():
	music.stop()
	_playMusic(loseMusic)

func _playMusic(musicClip: AudioStream):
	music.stream = musicClip
	music.play()

func _playSoundEffect(soundClip: AudioStream):
	soundEffects.stream = soundClip
	soundEffects.play()
