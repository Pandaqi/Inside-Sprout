class_name ModuleElementGrabber extends Node2D

signal available_for_processing(ed:ElementType)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not (body is Element): return
	if not (body.type.pickupable): return
	
	body.kill()
	available_for_processing.emit(body.type)
