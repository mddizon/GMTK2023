extends Button

@export var stats: BugStats
@export var open = false

signal zone_toggled(index, toggled)

var index = 0

func _on_pressed():
    text = ''
    var staged_bug_stats = GlobalTypes.selected_stats
    print(staged_bug_stats, stats)
    if GlobalTypes.active_zones[index] == false or staged_bug_stats != stats:
        stats = staged_bug_stats
        icon = stats.img
        GlobalTypes.active_stats[index] = stats
        GlobalTypes.active_zones[index] = true
    else:
        icon = null
        text = '*'
        GlobalTypes.active_zones[index] = false
