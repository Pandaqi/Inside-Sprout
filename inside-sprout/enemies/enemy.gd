class_name Enemy extends CharacterBody2D

var type : EnemyType
var dead := false

@onready var mover := $Mover
@onready var sprite : Sprite2D = $Sprite2D
@onready var health := $Health
@onready var properties := $Properties
@onready var map_tracker := $MapTracker
@onready var sensor := $Sensor

signal died(e:Enemy)

func activate() -> void:
	health.depleted.connect(on_health_depleted)
	map_tracker.activate()
	sensor.activate()

func set_type(tp:EnemyType) -> void:
	type = tp
	
	sprite.set_frame(tp.frame)
	mover.res_move = tp.movement_type
	health.set_base_health(tp.health * Global.config.enemy_health_factor, true)
	properties.set_type(tp)
	# @TODO: update everything accordingly

func on_health_depleted() -> void:
	kill()

func kill() -> void:
	dead = true
	died.emit(self)
	self.queue_free()
