class_name ElementSprite extends Node2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var bg := $BG
@onready var anim_player : AnimationPlayer = $AnimationPlayer

func set_data(tp:ElementType, weak:bool) -> void:
	bg.modulate = tp.color
	sprite.set_frame(tp.frame)
	#if weak: anim_player.play("is_weak")
