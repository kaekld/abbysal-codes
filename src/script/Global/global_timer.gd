extends Node

var timer := Timer.new()
var elapsed_time := 0

func _ready():
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_timer_timeout():
	elapsed_time += 1

func start_timer():
	if timer.is_stopped():
		timer.start()

func stop_timer():
	if not timer.is_stopped():
		timer.stop()

func reset_timer():
	elapsed_time = 0
	timer.start()
