class_name Enemy extends CharacterBody2D

var type : EnemyType
var dead := false

@onready var mover := $Mover
@onready var sprite : Sprite2D = $Sprite2D
@onready var health := $Health

signal died(e:Enemy)

func activate() -> void:
	pass

func set_type(tp:EnemyType) -> void:
	type = tp
	
	sprite.set_frame(tp.frame)
	mover.res_move = tp.movement_type
	health.set_base_health(tp.health * Global.config.enemy_health_factor, true)
	# @TODO: update everything accordingly

func kill() -> void:
	dead = true
	died.emit(self)
	self.queue_free()
