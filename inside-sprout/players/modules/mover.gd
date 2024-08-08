class_name ModuleMover extends Node2D

@export var input : ModuleInput
@export var res_move : MovementType
@export var sensor : ModuleSensor
@export var map_data : MapData
@onready var entity : CharacterBody2D = get_parent()

var speed_factor := 1.0
@export var extra_speed_factor := 1.0

func activate():
	extra_speed_factor = Global.config.movement_speed_factor_player

func _physics_process(_dt:float) -> void:
	if not res_move: return
	
	var vec = res_move.update(self)
	entity.velocity = vec
	entity.move_and_slide()

func get_speed_factor() -> float:
	return speed_factor * Global.config.movement_speed_def * extra_speed_factor
