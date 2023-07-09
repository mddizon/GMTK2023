extends Camera2D

@export var shake_amount:float = 0.0
@export var default_offset:Vector2 = Vector2(0,0)

var pos_x: int = 0
var pos_y: int = 0

@onready var timer: Timer = $Timer
@onready var tween: Tween = create_tween()

func _ready():
	set_process(true)
	randomize()

func _process(delta):
	offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)

func shake(duration:float, amount:float):
	shake_amount = amount
	timer.set_wait_time(duration)
	set_process(true)
	timer.start()

func _on_timer_timeout():
	set_process(false)
	tween.interpolate_value(self, "offset", 1, 1, tween.TRANS_LINEAR, tween.EASE_IN)
