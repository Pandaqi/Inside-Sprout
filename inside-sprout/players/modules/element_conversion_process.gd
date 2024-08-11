class_name ElementConversionProcess

var type : ElementType
var duration := 0.0
var time_spent := 0.0

signal finished()

func _init(dur:float, tp:ElementType) -> void:
	duration = dur
	type = tp

func update(dt:float) -> void:
	change(dt)

func get_ratio() -> float:
	return time_spent / duration

func get_time_remaining() -> float:
	return duration - time_spent

func finish() -> void:
	change(duration)

func change(val:float) -> void:
	time_spent += val
	if time_spent >= duration: 
		finished.emit(self)
