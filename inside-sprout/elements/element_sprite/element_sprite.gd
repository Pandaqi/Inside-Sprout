class_name ElementSprite extends Node2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var anim_player : AnimationPlayer = $AnimationPlayer

func set_data(frm:int, weak:bool) -> void:
	sprite.set_frame(frm)
	if weak: anim_player.play("is_weak")
