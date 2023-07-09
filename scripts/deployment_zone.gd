extends Button

@export var stats: BugStats
@export var open = false

signal zone_toggled(index, toggled)

var index = 0

func _process(_delta):
	if Input.is_action_just_pressed("Stage%s" % (index + 1)):
		_on_pressed()

func _on_pressed():
	var staged_bug_stats = GlobalTypes.selected_stats
	# Also dumb, checking cost to get around the stat objects not being equal on ready
	if GlobalTypes.active_zones[index] == false or staged_bug_stats.cost != GlobalTypes.active_stats[index].cost:
		stats = staged_bug_stats
		icon = stats.img
		GlobalTypes.active_stats[index] = stats
		GlobalTypes.active_zones[index] = true
	else:
		icon = null
		GlobalTypes.active_zones[index] = false
