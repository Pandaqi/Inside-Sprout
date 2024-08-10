class_name Element extends StaticBody2D

var type : ElementType

@onready var sprite := $Sprite2D
@onready var attacker := $Attacker
@onready var health := $Health
@onready var map_tracker : ModuleMapTracker = $MapTracker
@onready var state := $State

signal died(e:Element)

func activate() -> void:
	state.activate()
	map_tracker.activate()

func set_type(tp:ElementType) -> void:
	type = tp
	
	var base_health := tp.health * map_tracker.get_rules().elements_health_factor * Global.config.elements_health_factor
	health.set_base_health(base_health, true)
	sprite.set_frame(tp.frame)
