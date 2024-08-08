class_name Enemies extends Node2D

var spawner : SpawnerWaves

@export var enemy_scene : PackedScene
@export var enemy_data : EnemyData
@export var map_data : MapData

func activate() -> void:
	enemy_data.reset()
	
	spawner = SpawnerWaves.new()
	spawner.set_config(enemy_scene, enemy_data, map_data)
	spawner.wave_ended.connect(on_wave_ended)
	enemy_data.spawner = spawner
	
	load_next_wave()

func load_next_wave() -> void:
	spawner.start()

func _process(_dt:float) -> void:
	spawner.update()

# @TODO: obviously have a delay, show that wave is progressing, etcetera
func on_wave_ended() -> void:
	print("WAVE OVER ", spawner.wave_index)
	spawner.start()
