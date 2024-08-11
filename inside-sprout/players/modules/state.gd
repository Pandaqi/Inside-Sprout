class_name ModuleState extends Node2D

var dead := false

@onready var entity = get_parent()
@export var health : ModuleHealth
@export var death_effects_scene : PackedScene 

signal died(p:Player)

func activate() -> void:
	if not health: return
	health.depleted.connect(kill)

func kill() -> void:
	if dead: return
	
	var de = death_effects_scene.instantiate()
	de.set_position(global_position)
	get_tree().get_root().add_child(de)
	
	dead = true
	died.emit(entity)
	entity.queue_free()
