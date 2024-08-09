class_name Heart extends StaticBody2D

# @TODO: in the future, just create a ModuleDeath or ModuleStatus, so I can give that to all objects instead of repeating this dead/kill code

@onready var health := $Health
@onready var sprite := $Sprite2D

var type : MachineType
var dead := false

signal died(h:Heart)

func _ready() -> void:
	health.depleted.connect(on_health_depleted)
	health.set_base_health(Global.config.heart_health * Global.config.enemy_damage_factor, true)

func set_direction(angle:float) -> void:
	set_rotation(angle)

func set_type(tp:MachineType) -> void:
	type = tp
	
	sprite.set_frame(tp.frame)
	sprite.flip_h = false
	if not is_horizontal(): 
		sprite.set_frame(tp.frame_vertical)
		sprite.flip_h = is_equal_approx(get_rotation(), -0.5*PI)

func is_horizontal() -> bool:
	return is_equal_approx(get_rotation(), 0) or is_equal_approx(get_rotation(), PI)

func on_health_depleted() -> void:
	kill()

func kill() -> void:
	dead = true
	died.emit(self)
	self.queue_free()
