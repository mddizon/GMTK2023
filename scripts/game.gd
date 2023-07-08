extends Node2D

@onready var ship = $Ship
@onready var spawn_position = $ShipSpawnPosition
@onready var bullet_container = $BulletContainer
@onready var unit_container = $UnitContainer
@onready var bomb_counter = $Control/PanelContainer/Rows/BombContainer/BombRows/BombColumns
@onready var resource_counter = $Control/PanelContainer/Rows/ResourceContainer/VBoxContainer/Resource

#This sucks but whatever
@onready var bug_row_1 = $Control/PanelContainer/Rows/ResourceContainer/VBoxContainer/BugMarket/BugRow1
@onready var bug_row_2 = $Control/PanelContainer/Rows/ResourceContainer/VBoxContainer/BugMarket/BugRow2

#Timer
@onready var timer = $GameOverTimer
@onready var gameover_label = $Control/PanelContainer/Rows/DistanceContainer/VBoxContainer/DistanceValue

@export var units: Array[BugStats] = []
@export var num_bombs = 3
@export var resources = 100
@export var spawn_cooldown = 1
@export var total_distance = 5000

var bomb_texture = preload("res://assets/HumanShip/BombCounter.png")
var Unit = preload("res://scenes/unit.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	ship.global_position = spawn_position.global_position
	ship.ship_fired.connect(_on_ship_fired)
	ship.ship_hit.connect(_on_ship_hit)
	
	var buttons = bug_row_1.get_children()
	buttons.append_array(bug_row_2.get_children())
	
	for button in buttons:
		button.spawn_bug.connect(_on_spawn_bug)
	
	updateBombLabel()
	updateResourceLabel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	updateDistanceLabel()

func _on_ship_fired(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	bullet_container.add_child(laser)

func _on_ship_hit():
	if num_bombs > 0:
		for n in unit_container.get_children():
			n.queue_free()
		for n in bullet_container.get_children():
			n.queue_free()
		num_bombs -= 1
		updateBombLabel()
	else:
		ship.queue_free()

func _on_spawn_bug(stats:BugStats):
	if (stats.cost <= resources):
		var bug = Unit.instantiate()
		bug.global_position = Vector2(randf_range(50, 340), 50)
		bug.stats = stats
		bug.bug_fired.connect(_on_bug_fired)
		unit_container.add_child(bug)
		resources -= stats.cost
		updateResourceLabel()

func _on_bug_fired(scene, location, speed):
	var laser = scene.instantiate()
	laser.speed = speed
	laser.global_position = location
	bullet_container.add_child(laser)

func updateBombLabel():
	for n in bomb_counter.get_children():
		n.queue_free()

	for i in num_bombs:
		var textureRect = TextureRect.new()
		textureRect.texture = bomb_texture
		bomb_counter.add_child(textureRect)

func updateResourceLabel():
	resource_counter.text = "Larvae: %s" % resources

func updateDistanceLabel():
	var remainingTime = timer.wait_time - timer.time_left
	var parsecs = total_distance - remainingTime/timer.wait_time * total_distance
	gameover_label.text = "%d Parsecs" % parsecs

func _on_game_over_timer_timeout():
	if num_bombs >= 0:
		print('You Lose!')
