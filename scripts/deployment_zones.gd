extends Control

@onready var Background = $TextureRect
@onready var ZoneContainer = $ZoneContainer
@onready var Deploy = $Deploy
@onready var label = $Label

signal zone_spawn_toggled(index, zone_scene, remove)
signal deploy_zones

var button_down = preload("res://assets/UI/Spawners_pushed.png")
var button_up = preload("res://assets/UI/Spawners.png")
var deployment_zone = preload("res://scenes/deployment_zone.tscn")

var cooldown_timer = 0.0
@export var cooldown_value = 0.5
var canBuy = true

func _ready():
	for i in GlobalTypes.deployment_positions.size():
		var zone = deployment_zone.instantiate()
		zone.index = i
		
		#This is really dumb, change this if you ever bother
		if i == 2:
			zone.icon = load("res://assets/Bugs/Bug_Blue_1.png")
		ZoneContainer.add_child(zone)

func _process(delta):
	if cooldown_timer <= 0.0:
		canBuy = true
	else:
		cooldown_timer -= delta
	
	if Input.is_action_just_pressed("spawn"):
		_on_deploy_button_down()
	
	if Input.is_action_just_released("spawn"):
		_on_deploy_button_up()
		_on_deploy_pressed()
	
	#Should probably get this from a signal
	updateCostText()

func _on_deploy_pressed():
	if canBuy:
		cooldown_timer = cooldown_value
		deploy_zones.emit()
		canBuy = false

func _on_deploy_button_down():
	Background.texture = button_down

func _on_deploy_button_up():
	Background.texture = button_up

func updateCostText():
	var cost = GlobalTypes.calculate_cost()
	label.text = "* -%d" % cost
