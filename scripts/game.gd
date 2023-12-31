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

#Animations
@onready var powerup_label = $PowerupLabel
@onready var explosion = $Asplosion
@onready var animation_player = $AnimationPlayer
@onready var camera = $ShakyCam

@export var units: Array[BugStats] = []
@export var num_bombs = 3
@export var resources = 400
@export var spawn_cooldown = 1
@export var total_distance = 5000
@export var powerup_time = 5
var powerup_time_remaining = 0

var bomb_texture = preload("res://assets/HumanShip/BombCounter.png")
var game_over = preload("res://scenes/game_over.tscn")
var Unit = preload("res://scenes/unit.tscn")
var DeploymentZone = preload("res://scenes/deployment_zone.tscn")

var active_deployment_zones = [null, null, null, null, null]

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalTypes.won = false
	GlobalTypes.active_zones = [false, false, true, false, false]
	GlobalTypes.active_stats = [null, null, null, null, null]
	GlobalTypes.selected_stats = null
	GlobalTypes.active_powerups = {}
	GlobalTypes.powerup_time_remaining = 0

	ship.global_position = spawn_position.global_position
	ship.ship_fired.connect(_on_ship_fired)
	ship.ship_hit.connect(_on_ship_hit)
	
	var buttons = bug_row_1.get_children()
	buttons.append_array(bug_row_2.get_children())

	for i in buttons.size():
		var bug_button = buttons[i]
		bug_button.index = i
		bug_button.spawn_bug.connect(_on_stage_bug)

	buttons[0].button_pressed = true

	# Also really dumb. I wanted to have one of the deployment zones active at
	# The beginning so I had to hack it in a bunch of places
	GlobalTypes.selected_stats = buttons[0].stats
	GlobalTypes.active_stats[2] = buttons[0].stats
	
	for i in GlobalTypes.active_stats.size():
		GlobalTypes.active_stats[i] = GlobalTypes.selected_stats

	AudioManager.playGameMusic()
	
	explosion.animation_finished.connect(_on_explosion_animation_finished)

	updateBombLabel()
	updateResourceLabel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for powerup in GlobalTypes.active_powerups.keys():
		GlobalTypes.active_powerups[powerup] -= delta
		if GlobalTypes.active_powerups[powerup] <= 0:
			GlobalTypes.active_powerups.erase(powerup)
	
	updateDistanceLabel()

func _on_ship_fired(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	bullet_container.add_child(laser)
	AudioManager.playLaserSound()

func _on_ship_hit():
	if num_bombs > 0:
		for n in unit_container.get_children():
			n.queue_free()
		for n in bullet_container.get_children():
			n.queue_free()
		num_bombs -= 1
		updateBombLabel()
		explosion.visible = true
		AudioManager.playShipDeathSound()
		explosion.play('default')
		camera.shake(.3, 5)
	else:
		ship.queue_free()
		GlobalTypes.won = true
		get_tree().change_scene_to_packed(game_over)

func _on_explosion_animation_finished():
	explosion.visible = false

func _on_stage_bug(stats: BugStats):
	GlobalTypes.selected_stats = stats

func deploy_bugs():
	var cost = GlobalTypes.calculate_cost();
	if cost <= resources:
		for i in GlobalTypes.deployment_positions.size():
			var zone_position = GlobalTypes.deployment_positions[i]
			var active = GlobalTypes.active_zones[i]
			var stats = GlobalTypes.active_stats[i]
			if (active && stats):
				spawn_bug(zone_position, stats)
		resources -= cost
		updateResourceLabel()
		AudioManager.playBugLaunchSound()

func spawn_bug(zone_position, stats):
	var bug = Unit.instantiate()
	bug.global_position = zone_position
	bug.add_to_group("bugs")
	bug.stats = stats
	bug.bug_fired.connect(_on_bug_fired)
	bug.bug_died.connect(_on_bug_died)
	unit_container.add_child(bug)

func _on_bug_died(drop_rate, powerups):
	#Roll for powerups
	var roll = randf()
	if roll < drop_rate:
		var powerup = randi_range(0, powerups.size())
		GlobalTypes.active_powerups[powerup] = powerup_time
		AudioManager.playPowerupSound()
		powerup_label.visible = true
		animation_player.play("PowerupToast")
	else:
		AudioManager.playBugDeathSound()

func _on_bug_fired(scene, location, speed):
	var laser = scene.instantiate()
	laser.add_to_group("bugs")
	laser.speed = speed
	laser.global_position = location
	bullet_container.add_child(laser)
	AudioManager.playLaserSound()

func updateBombLabel():
	for n in bomb_counter.get_children():
		n.queue_free()

	for i in num_bombs:
		var textureRect = TextureRect.new()
		textureRect.texture = bomb_texture
		bomb_counter.add_child(textureRect)

func updateResourceLabel():
	resource_counter.text = "Larvae: *%s" % resources

func updateDistanceLabel():
	var remainingTime = timer.wait_time - timer.time_left
	var parsecs = total_distance - remainingTime/timer.wait_time * total_distance
	gameover_label.text = "%d Parsecs" % parsecs

func _on_game_over_timer_timeout():
	if num_bombs >= 0:
		GlobalTypes.won = false
		get_tree().change_scene_to_packed(game_over)

func _on_deployment_zones_zone_spawn_toggled(index, _zone, remove):
	GlobalTypes.active_zones[index] = not remove
	if !remove:
		GlobalTypes.active_stats[index] = GlobalTypes.selected_stats

func _on_deployment_zones_deploy_zones():
	deploy_bugs()
