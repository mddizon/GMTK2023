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
	Vector2(36, 60),
	Vector2(108, 60),
	Vector2(180, 60),
	Vector2(252, 60),
	Vector2(324, 60)
]

# Player stats, should really be its own resource
var won = false
var active_zones = [false, false, false, false, false]
var active_stats: Array[BugStats] = [null, null, null, null, null]
var selected_stats = null
