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

const clampBegin = Vector2(20, 440);
const clampEnd = Vector2(340, 440);
