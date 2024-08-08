class_name ModuleAttacker extends Node2D

@onready var entity = get_parent()
@onready var timer := $Timer
@onready var kill_area := $KillArea
@export var attack_if_provoked := true
@export var never_attack_first := false
var target : Node2D

signal target_found(n:Node2D)
signal attacked(n:Node2D)
signal target_lost(n:Node2D)

func attack() -> void:
	if not get_target(): return
	
	var damage : float = entity.type.damage * Global.config.enemy_damage_factor - entity.type.shield * Global.config.enemy_shield_factor
	target.health.change(-damage)
	if ("attacker" in target): target.attacker.provoke(entity)
	attacked.emit(target)
	restart_timer()

func restart_timer():
	if not is_instance_valid(timer): return # we died while doing our attack
	timer.wait_time = entity.type.attack_delay * Global.config.enemy_attack_delay_factor
	timer.start()

func _on_timer_timeout() -> void:
	attack()

func get_target() -> Node2D:
	if target and not is_instance_valid(target): reset_target()
	return target

func set_target(t:Node2D) -> void:
	if not can_damage_target(t): return
	
	target = t
	target_found.emit(target)
	attack()

func reset_target() -> void:
	timer.stop()
	target_lost.emit(target)
	target = null
	recheck_bodies()

func recheck_bodies() -> void:
	for body in kill_area.get_overlapping_bodies():
		_on_kill_area_body_entered(body)

# only switch to new candidates if we don't already have one
func _on_kill_area_body_entered(body: Node2D) -> void:
	if never_attack_first: return
	if body == entity: return
	if get_target(): return
	
	var can_be_target := ("health" in body)
	if not can_be_target: return

	set_target(body)

func _on_kill_area_body_exited(body: Node2D) -> void:
	if body == target: reset_target()

func provoke(attacker:Node2D) -> void:
	if not attack_if_provoked: return
	set_target(attacker)

# @TODO: some cleaner code structure/module/resource/whatever to check if things can hit each other
func can_damage_target(body = target) -> bool:
	if (body is Enemy) and (entity is Element):
		return body.type.is_weak_to(entity.type)
	return true
