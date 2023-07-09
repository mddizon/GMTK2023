extends Area2D

class_name Unit

signal bug_fired(scene, location, speed)
signal bug_died(drop_rate, powerups)

@onready var sprite = $Sprite2D
@onready var shotPosition = $ShotPosition

var stats: BugStats = null

@export var wave_amplitude = 100
@export var wave_frequency = 5
var offset = Vector2.ZERO
var time = 0
var cooldown_timer = 0.0
var laser_scene = preload("res://scenes/bug_bullet.tscn")

func _ready():
	sprite.texture = stats.img

func _physics_process(delta):
	var movement = stats.move_pattern
	time += delta
	# Movement
	if (movement == GlobalTypes.Movement.DOWN):
		position.y += stats.move_speed * delta
	elif (movement == GlobalTypes.Movement.LEFT_WAVE):
		var move = sin(time * wave_frequency) * wave_amplitude
		position.x += move * delta
		position.y += stats.move_speed * delta
	elif (movement == GlobalTypes.Movement.RIGHT_WAVE):
		var move = -sin(time * wave_frequency) * wave_amplitude
		position.x += move * delta
		position.y += stats.move_speed * delta
		
	position.clamp(GlobalTypes.clampBegin, GlobalTypes.clampEnd)
	
	# Shoot
	if stats.attack_pattern != GlobalTypes.Attack.COLLISION:
		if cooldown_timer <= 0.0:
			bug_fired.emit(laser_scene, shotPosition.global_position, stats.shot_speed)
			cooldown_timer = stats.shot_cooldown
		else:
			cooldown_timer -= delta

func die():
	bug_died.emit(stats.drop_rate, stats.powerup)
	queue_free()

func _on_body_entered(body):
	if body is Ship:
		body.hit()
		die()

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
