class_name Enemy extends CharacterBody2D

var type : EnemyType

@onready var mover := $Mover
@onready var health := $Health
@onready var properties := $Properties
@onready var map_tracker := $MapTracker
@onready var sensor := $Sensor
@onready var attacker := $Attacker
@onready var state := $State
@onready var visuals := $Visuals

func activate() -> void:
	state.activate()
	map_tracker.activate()
	sensor.activate()
	state.died.connect(on_death)

func set_type(tp:EnemyType) -> void:
	type = tp
	
	visuals.set_data(tp)
	mover.res_move = tp.movement_type
	mover.speed_factor = tp.speed
	health.set_base_health(tp.health * Global.config.enemy_health_factor, true)
	properties.set_type(tp)
	sensor.set_type(tp)
	attacker.set_type(tp)

func on_death(_n) -> void:
	if map_tracker.get_rules().enemies_drop_seeds:
		var num := Global.config.enemy_seed_drop_bounds.rand_int()
		for _i in range(num):
			var rand_scatter := Vector2.from_angle(randf() * 2 * PI) * Global.config.sprite_size
			GSignal.drop_element.emit(null, global_position + rand_scatter)
