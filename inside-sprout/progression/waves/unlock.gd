extends Node2D

@onready var icon := $Icon
@onready var label := $Label

func set_data(tp:EnemyType) -> void:
	icon.set_frame(tp.frame)
	label.set_text(tp.desc)
