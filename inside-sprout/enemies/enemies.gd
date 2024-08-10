class_name Enemies extends Node2D

var spawner : SpawnerWaves

@export var enemy_scene : PackedScene
@export var enemy_data : EnemyData
@export var map_data : MapData
@export var element_data : ElementData
@export var prog_data : ProgressionData

func activate() -> void:
	enemy_data.reset()
	
	spawner = SpawnerWaves.new()
	spawner.set_config(enemy_scene, enemy_data, map_data, element_data, prog_data)
	spawner.wave_ended.connect(on_wave_ended)
	enemy_data.spawner = spawner

func load_next_wave() -> void:
	spawner.start()

func _process(_dt:float) -> void:
	spawner.update()

func on_wave_ended() -> void:
	print("WAVE OVER ", spawner.wave_index)
