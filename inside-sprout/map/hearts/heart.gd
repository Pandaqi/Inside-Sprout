class_name Heart extends StaticBody2D

# @TODO: in the future, just create a ModuleDeath or ModuleStatus, so I can give that to all objects instead of repeating this dead/kill code

@onready var health := $Health

var dead := false

signal died(h:Heart)

func _ready() -> void:
	health.depleted.connect(on_health_depleted)
	health.set_base_health(Global.config.heart_health * Global.config.enemy_damage_factor, true)

func on_health_depleted() -> void:
	kill()

func kill() -> void:
	dead = true
	died.emit(self)
	self.queue_free()
