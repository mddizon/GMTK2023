extends Control

@onready var ZoneContainer = $ZoneContainer
@onready var Deploy = $Deploy

signal zone_spawn_toggled(index, zone_scene, remove)
signal deploy_zones

var deployment_zone = preload("res://scenes/deployment_zone.tscn")

var cooldown_timer = 0.0
@export var cooldown_value = 0.5
var canBuy = true

func _ready():
	for i in GlobalTypes.deployment_positions.size():
		var zone = deployment_zone.instantiate()
		zone.index = i
		ZoneContainer.add_child(zone)

func _process(delta):
	if cooldown_timer <= 0.0:
		canBuy = true
	else:
		cooldown_timer -= delta

func _on_deploy_pressed():
	if canBuy:
		cooldown_timer = cooldown_value
		deploy_zones.emit()
		canBuy = false
