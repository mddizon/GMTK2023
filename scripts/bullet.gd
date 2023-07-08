extends Area2D
class_name ShipBullet

@export var speed = 100

func _physics_process(delta):
	global_position.y += speed * delta * -1

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area is Unit:
		queue_free()
		area.die()
