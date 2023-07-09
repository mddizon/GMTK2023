extends CharacterBody2D

class_name Ship

signal ship_fired(laser_scene, location)
signal ship_hit

@export var speed = 300.0
@export var shotSpeed = .5
@export var powerupSpeed = .15
@export var turnSpeed = 1.0
@export var moveSpeed = 200

@onready var shotPosition = $ShotPosition

var powerup_timer = 10
var powerups = []

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
		cooldown_timer = powerupSpeed if _can_use_powerup(GlobalTypes.Powers.FIRE_RATE) else shotSpeed
	else:
		cooldown_timer -= delta

	move_and_slide()
	
	global_position = global_position.clamp(GlobalTypes.clampBegin, GlobalTypes.clampEnd)

func _can_use_powerup(powerup: GlobalTypes.Powers):
	var has_powerup = GlobalTypes.active_powerups.has(powerup)
	var is_powerup_active = 0
	if (has_powerup):
		is_powerup_active = GlobalTypes.active_powerups[powerup] > 0
	return has_powerup && is_powerup_active

func chooseRandomDirection():
	turnSpeed = randf() + 1
	velocity.x = velocity.x * -1
	
func hit():
	ship_hit.emit()
