class_name ElementConversionProcess extends Node

var type : ElementType
var duration := 0.0
var timer : Timer

signal finished()

func _init(dur:float, tp:ElementType) -> void:
	duration = dur
	type = tp

func create_timer() -> void:
	timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.timeout.connect(on_timer_timeout)
	add_child(timer)
	timer.start()

func on_timer_timeout() -> void:
	finished.emit(self)
