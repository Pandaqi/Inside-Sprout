extends Node2D

@onready var sprite := $SpriteRadius
@export var color := Color(1,1,1)

func _ready() -> void:
	sprite.material = sprite.material.duplicate(false)
	sprite.material.set_shader_parameter("color", color)

func update(r:float) -> void:
	sprite.set_scale(2.0 * r / Global.config.sprite_size * Vector2.ONE)
	sprite.material.set_shader_parameter("thickness", 0.02 / sprite.scale.x)
	sprite.material.set_shader_parameter("frequency", 25 / sprite.scale.x)
