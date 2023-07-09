extends Node

enum Movement {
	DOWN,
	LEFT_WAVE,
	RIGHT_WAVE,
	NONE
}

enum Attack {
	COLLISION,
	STRAIGHT,
	DIAGONAL,
	SPREAD
}

enum Powers {
	FIRE_RATE,
	SPREAD,
	SHIELD,
	BOMB
}

const clampBegin = Vector2(20, 440)
const clampEnd = Vector2(340, 440)

# I can't be bothered so i'm just hardcoding this
var deployment_positions = [
	Vector2(38, 60),
	Vector2(110, 60),
	Vector2(182, 60),
	Vector2(254, 60),
	Vector2(326, 60)
]

# Player stats, should really be its own resource
var won = false
var active_zones = [false, false, false, false, false]
var active_stats: Array[BugStats] = [null, null, null, null, null]
var selected_stats = null
var active_powerups = {}
var powerup_time_remaining = 0

# Util functions
func calculate_cost():
	var cost = 0;
	for i in GlobalTypes.active_zones.size():
		if (GlobalTypes.active_zones[i]):
			cost += GlobalTypes.active_stats[i].cost
	return cost
