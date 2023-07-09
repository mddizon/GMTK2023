extends Control

var game = preload("res://scenes/game.tscn")
var credits = preload("res://scenes/credits.tscn")

func _ready():
	AudioManager.playStartMusic()

func _on_button_pressed():
	get_tree().change_scene_to_packed(game)

func _on_credits_pressed():
	get_tree().change_scene_to_packed(credits)
