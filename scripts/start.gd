extends Control

var game = preload("res://scenes/game.tscn")

func _on_button_pressed():
	var gameInstance = game.instantiate()
	get_tree().change_scene_to_packed(game)
