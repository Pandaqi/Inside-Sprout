extends Node2D

@onready var audio_player := $AudioStreamPlayer2D
@onready var particles := $LeafExplosion

func _ready() -> void:
	audio_player.pitch_scale = randf_range(0.9, 1.1)
	audio_player.play()
	await particles.done
	queue_free()
