extends Control


func _on_back_pressed():
	var start = load("res://scenes/start.tscn")
	get_tree().change_scene_to_packed(start)
