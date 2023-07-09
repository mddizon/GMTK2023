extends Resource
class_name BugStats

@export var cost = 1
@export var move_pattern: GlobalTypes.Movement = GlobalTypes.Movement.DOWN
@export var move_speed = 200
@export var attack_pattern: GlobalTypes.Attack = GlobalTypes.Attack.COLLISION
@export var shot_cooldown = 1
@export var shot_speed = 200
@export var powerup: Array[GlobalTypes.Powers] = [GlobalTypes.Powers.FIRE_RATE]
@export var drop_rate = 0.0
@export var img: Texture = null
