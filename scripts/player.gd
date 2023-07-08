extends CharacterBody2D

class_name Ship

signal ship_fired(laser_scene, location)
signal ship_hit

@export var speed = 300.0
@export var shotSpeed = .5
@export var turnSpeed = 1.0
@export var moveSpeed = 200

@onready var shotPosition = $ShotPosition

var move_timer = 0.0
var cooldown_timer = 0.0

var laser_scene = preload("res://scenes/bullet.tscn")

func _ready():
	velocity.x = moveSpeed

func _physics_process(delta):
	if move_timer <= 0.0:
		chooseRandomDirection()
		move_timer = turnSpeed
	else:
		move_timer -= delta

	if cooldown_timer <= 0.0:
		ship_fired.emit(laser_scene, shotPosition.global_position)
		cooldown_timer = shotSpeed
	else:
		cooldown_timer -= delta

	move_and_slide()
	
	global_position = global_position.clamp(GlobalTypes.clampBegin, GlobalTypes.clampEnd)

func chooseRandomDirection():
	turnSpeed = randf() + 1
	velocity.x = velocity.x * -1
	
func hit():
	ship_hit.emit()
