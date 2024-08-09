class_name Element extends StaticBody2D

var type : ElementType
var dead := false

@onready var sprite := $Sprite2D
@onready var attacker := $Attacker
@onready var health := $Health
@onready var map_tracker := $MapTracker

signal died(e:Element)

func activate() -> void:
	health.depleted.connect(on_health_depleted)
	map_tracker.activate()

func set_type(tp:ElementType) -> void:
	type = tp
	
	health.set_base_health(tp.health * Global.config.elements_health_factor, true)
	sprite.set_frame(tp.frame)
	# @TODO: visuals and other changes and stuff

func on_health_depleted() -> void:
	kill()

func kill() -> void:
	dead = true
	died.emit(self)
	queue_free()
