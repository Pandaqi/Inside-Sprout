extends Node2D

var velocity := Vector2.ZERO
var hits_dealt := 0
var damage_factor := 1.0

func _physics_process(dt:float) -> void:
	set_position( get_position() + velocity*dt )

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not (body is Enemy): return
	var damage := Global.config.gun_bullet_damage * damage_factor * Global.config.enemy_health_factor
	body.health.change(-damage)
	hits_dealt += 1
	if hits_dealt >= Global.config.gun_bullet_max_hits * damage_factor:
		kill()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	kill()

func kill() -> void:
	queue_free()
