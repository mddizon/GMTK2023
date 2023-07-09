extends Control

@onready var title = $MarginContainer2/VBoxContainer/Title
@onready var description = $MarginContainer2/VBoxContainer/Description

var game = preload("res://scenes/game.tscn")

@export var win_title = ""
@export var lose_title = ""
@export_multiline var win_text = ""
@export_multiline var lose_text = ""

func _ready():
	if GlobalTypes.won:
		title.text = win_title
		description.text = win_text
		AudioManager.playWinMusic()
	else:
		title.text = lose_title
		description.text = lose_text
		AudioManager.playLoseMusic()

func _on_play_again_pressed():
	var start = load("res://scenes/start.tscn")
	get_tree().change_scene_to_packed(start)

