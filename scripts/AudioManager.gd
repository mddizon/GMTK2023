extends Node2D

@onready var music: AudioStreamPlayer = $Music
@onready var soundEffects: AudioStreamPlayer = $SoundChannel
@onready var soundEffects2: AudioStreamPlayer = $SoundChannel2
@onready var soundEffects3: AudioStreamPlayer = $SoundChannel3

var startMenuMusic = preload("res://assets/Audio/Music/Rising Tide (faster).mp3")
var gameMusic = preload("res://assets/Audio/Music/Voltaic.mp3")
var winMusic = preload("res://assets/Audio/Music/esm_8_bit_game_over_1_arcade_80s_simple_alert_notification_game.mp3")
var loseMusic = preload("res://assets/Audio/Music/esm_8_bit_game_over_2_arcade_80s_simple_alert_notification_game.mp3")

var powerupSound = preload("res://assets/Audio/SFX/warm_positive_chime_win_collect_item_point_78397.mp3")
var powerupSound2 = preload("res://assets/Audio/SFX/positive_bonus_win_glide_synth_001_51329.mp3")
var powerupSound3 = preload("res://assets/Audio/SFX/level_up_1_up_002_92312.mp3")
var powerupSounds = [powerupSound, powerupSound2, powerupSound3];

var laserSound = preload("res://assets/Audio/SFX/videogame-laser2.mp3")
var laserSound2 = preload("res://assets/Audio/SFX/laser_weapon_fire_002_25878.mp3")
var laserSounds = [laserSound, laserSound2]

var bugDeathSound = preload("res://assets/Audio/SFX/glitch_critter_electronic_102882.mp3")
var bugDeathSounds = [bugDeathSound]

var shipDeathSound = preload("res://assets/Audio/SFX/8bit_explosion_001.mp3")
var shipDeathSound2 = preload("res://assets/Audio/SFX/8bit_explosion_003.mp3")
var shipDeathSound3 = preload("res://assets/Audio/SFX/8bit_explosion_004.mp3")
var shipDeathSounds = [shipDeathSound, shipDeathSound2, shipDeathSound3]

var bugLaunchSound = preload("res://assets/Audio/SFX/dark_electronic_sequence_90919.mp3")
var bugLaunchSound2 = preload("res://assets/Audio/SFX/clicking_fluttering_hiss_102876.mp3")
var bugLaunchSounds = [bugLaunchSound, bugLaunchSound2]

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

func playPowerupSound():
	_playSoundEffect(powerupSounds)

func playLaserSound():
	_playSoundEffect(laserSounds)

func playBugDeathSound():
	_playSoundEffect(bugDeathSounds)

func playShipDeathSound():
	_playSoundEffect(shipDeathSounds)

func playBugLaunchSound():
	_playSoundEffect(bugLaunchSounds)	

func _playSoundEffect(sounds: Array):
	var soundClip = sounds[randi_range(0, sounds.size() - 1)]
	var channel = _findFreeChannel()
	if (channel != null):
		channel.stream = soundClip
		channel.play()

func _findFreeChannel():
	if soundEffects.playing == false:
		return soundEffects
	elif soundEffects2.playing == false:
		return soundEffects2
	elif soundEffects3.playing == false:
		return soundEffects3
	else:
		return null
