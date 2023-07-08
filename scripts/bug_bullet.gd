extends Area2D

var speed = 100

func _physics_process(delta):
	global_position.y += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area is ShipBullet:
		queue_free()
		area.queue_free()

func _on_body_entered(body):
	if body is Ship:
		body.hit()
		queue_free()

