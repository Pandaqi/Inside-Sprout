class_name ElementConversionSprite extends Node2D

var conv_proc : ElementConversionProcess
@onready var prog_bar := $Container/TextureProgressBar

func set_conv_proc(p:ElementConversionProcess) -> void:
	conv_proc = p

func update(dt:float) -> void:
	if not conv_proc: return
	prog_bar.set_value(conv_proc.get_ratio() * 100)
	conv_proc.update(dt)
