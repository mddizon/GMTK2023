extends Control

@onready var title = $MarginContainer2/VBoxContainer/Title
@onready var description = $MarginContainer2/VBoxContainer/Description

var game = preload("res://scenes/game.tscn")

@export var win_title = ""
@export var lose_title = ""
@export_multiline var win_text = ""
@export_multiline var lose_text = ""

func _ready():
	title.text = win_title if GlobalTypes.won else lose_title
	description.text = win_text if GlobalTypes.won else lose_text

func _on_play_again_pressed():
	get_tree().change_scene_to_packed(game)
