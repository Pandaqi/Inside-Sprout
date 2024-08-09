extends Node2D

@onready var sprite := $SpriteRadius
@export var color := Color(1,1,1)

func _ready() -> void:
	sprite.material = sprite.material.duplicate(false)
	sprite.material.set_shader_parameter("color", color)

func update(col_shape:CollisionShape2D) -> void:
	sprite.set_scale(2.0 * col_shape.shape.radius / Global.config.sprite_size * Vector2.ONE)
