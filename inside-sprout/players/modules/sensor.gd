class_name ModuleSensor extends Node2D

var target : Element = null
@onready var entity : Enemy = get_parent()

func set_target_element(e:Element):
	target = e

func get_target_element() -> Element:
	if target and not is_instance_valid(target): target = null
	return target

func _on_scan_area_body_entered(body: Node2D) -> void:
	if not (body is Element): return
	
	var data : EnemyType = entity.type
	if not data.distracted_by(body.type): return
	
	if not target: 
		set_target_element(body)
		return
	
	# only switch to newly seen things if they are closer
	# (I want to prevent having to re-check overlapping bodies EVERY FRAME)
	var dist_cur := target.global_position.distance_squared_to(global_position)
	var dist_new := body.global_position.distance_squared_to(global_position)
	if dist_cur < dist_new: return
	set_target_element(body)

func _on_kill_area_body_entered(body: Node2D) -> void:
	var die := false
	
	if body is Element:
		die = entity.type.is_weak_to(body.type)
		body.kill()
	
	if body is Heart:
		var damage := entity.type.damage * Global.config.enemy_damage_factor
		body.health.change(-damage)
		die = true
	
	if die:
		entity.kill()
