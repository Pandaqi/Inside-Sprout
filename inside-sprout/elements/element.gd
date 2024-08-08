class_name Element extends StaticBody2D

var type : ElementType
var dead := false

signal died(e:Element)

func set_type(tp:ElementType) -> void:
	type = tp
	
	# @TODO: visuals and other changes and stuff

func kill() -> void:
	dead = true
	died.emit(self)
	queue_free()
