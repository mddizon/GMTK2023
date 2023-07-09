extends Button

class_name BugButton

signal spawn_bug(stats: BugStats)

@export var stats: BugStats
@onready var cost = $Label

var cooldown_timer = 0.0
var cooldown_value = 0.5
var canBuy = true

func _ready():
	icon = stats.img
	cost.text = "*%d" % stats.cost

func _process(delta):
	if cooldown_timer <= 0.0:
		canBuy = true
	else:
		cooldown_timer -= delta

func _on_pressed():
	if canBuy:
		cooldown_timer = cooldown_value
		spawn_bug.emit(stats)
		canBuy = false
