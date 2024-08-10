extends Node2D

@onready var particles := $CPUParticles2D

func _ready() -> void:
	particles.set_emitting(true)
	await get_tree().create_timer(particles.lifetime).timeout
	queue_free()
