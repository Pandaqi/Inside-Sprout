class_name ModuleState extends Node2D

var dead := false

@export var health : ModuleHealth
var leaf_particles := preload("res://players/effects/leaf_explosion/leaf_explosion.tscn")

signal died(p:Player)

func activate() -> void:
	if not health: return
	health.depleted.connect(kill)

func kill() -> void:
	dead = true
	died.emit(self)
	var particles = leaf_particles.instantiate()
	particles.set_position(global_position)
	GSignal.place_on_map.emit("entities", particles)
	self.queue_free()
	
	var audio_player := AudioStreamPlayer2D.new()
	audio_player.stream = preload("res://players/modules/death.ogg")
	audio_player.pitch_scale = randf_range(0.9, 1.1)
	audio_player.max_distance = 5000
	GSignal.place_on_map.emit("entities", audio_player)
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()
