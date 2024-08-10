class_name ModuleElementGrabber extends Node2D

signal available_for_processing(ed:ElementType)

@onready var audio_player := $AudioStreamPlayer2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not (body is Element): return
	if not (body.type.pickupable): return
	
	body.state.kill()
	available_for_processing.emit(body.type)
	
	audio_player.pitch_scale = randf_range(0.9, 1.1)
	audio_player.play()
