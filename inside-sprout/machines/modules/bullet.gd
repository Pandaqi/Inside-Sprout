extends Node2D

var velocity := Vector2.ZERO

func _physics_process(dt:float) -> void:
	set_position( get_position() + velocity*dt )

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not (body is Enemy): return
	var damage := Global.config.gun_bullet_damage * Global.config.enemy_health_factor
	body.health.change(-damage)
