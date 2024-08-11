extends Node2D

@onready var sprite := $SpriteRadius
@export var color := Color(1,1,1)
@onready var anim_player := $AnimationPlayer

func _ready() -> void:
	sprite.material = sprite.material.duplicate(false)
	sprite.material.set_shader_parameter("color", color)
	anim_player.speed_scale = randf_range(0.9, 1.1)
	anim_player.play("fade_radius") # must be called AFTER duplicating the material

func update(r:float) -> void:
	sprite.set_scale(2.0 * r / Global.config.sprite_size * Vector2.ONE)
	sprite.material.set_shader_parameter("thickness", 0.03 / sprite.scale.x)
	sprite.material.set_shader_parameter("frequency", 25 * sprite.scale.x)
