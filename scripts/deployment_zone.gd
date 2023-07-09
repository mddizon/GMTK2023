extends Button

@export var stats: BugStats
@export var open = false

signal zone_toggled(index, toggled)

var index = 0

func _process(delta):
	if Input.is_action_just_pressed("Stage%s" % (index + 1)):
		_on_pressed()

func _on_pressed():
	var staged_bug_stats = GlobalTypes.selected_stats
	if GlobalTypes.active_zones[index] == false or staged_bug_stats != stats:
		stats = staged_bug_stats
		icon = stats.img
		GlobalTypes.active_stats[index] = stats
		GlobalTypes.active_zones[index] = true
	else:
		icon = null
		GlobalTypes.active_zones[index] = false
