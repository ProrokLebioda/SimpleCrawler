extends TextureRect

@onready var time_label = $Counter/Value
@export var cooldown = 1.0
@onready var timer = $Sweep/Timer
@onready var sweep = $Sweep

func _ready():
	timer.wait_time = cooldown
	time_label.hide()
	sweep.texture_progress = texture
	sweep.set_size(size)
	sweep.value = 0
	set_process(false)
	
func _process(delta):
	time_label.text = "%3.1f" % timer.time_left
	sweep.value = int((timer.time_left / cooldown) * sweep.max_value)

func _on_timer_timeout():
	print("Ability ready")
	sweep.value = 0
	time_label.hide()
	set_process(false)

func trigger_cooldown(cooldown_time : float):
	cooldown = cooldown_time
	timer.wait_time = cooldown
	set_process(true)
	timer.start()
	time_label.show()
