class_name Heart extends StaticBody2D

@onready var health := $Health
@onready var sprite := $Sprite2D
@onready var state := $State

var type : MachineType

func _ready() -> void:
	health.set_base_health(Global.config.heart_health * Global.config.enemy_damage_factor, true)

func activate() -> void:
	state.activate()

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
