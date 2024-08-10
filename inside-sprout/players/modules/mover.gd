class_name ModuleMover extends Node2D

@export var input : ModuleInput
@export var res_move : MovementType
@export var sensor : ModuleSensor
@export var map_data : MapData
@export var visuals : ModuleVisuals
@export var map_tracker : ModuleMapTracker
@onready var entity : CharacterBody2D = get_parent()
@onready var timer_pause : Timer = $TimerPause
@onready var particles := $CPUParticles2D

var paused := false
@export var speed_factor := 1.0

func activate() -> void:
	if (entity is Player):
		speed_factor = Global.config.movement_speed_factor_player

func _physics_process(dt:float) -> void:
	if not res_move: return
	if paused: return
	
	var vec := res_move.update(dt, self)
	var is_moving := vec.length() > 0.003
	entity.velocity = vec
	entity.move_and_slide()
	particles.set_emitting(is_moving)
	
	if visuals: 
		visuals.flip(vec.x < 0)
		visuals.animate(is_moving)
	

func get_speed_factor() -> float:
	var rules := map_tracker.get_rules()
	var specific_speed_factor := 1.0
	if (entity is Enemy): 
		specific_speed_factor = rules.speed_factor_enemy
	if (entity is Player): 
		specific_speed_factor = rules.speed_factor_player
	
	return speed_factor * Global.config.movement_speed_def * rules.speed_factor * specific_speed_factor

func pause():
	paused = true
	particles.set_emitting(false)
	timer_pause.start()

func unpause():
	paused = false
