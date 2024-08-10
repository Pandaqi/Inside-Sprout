class_name ModuleAttacker extends Node2D

@onready var entity = get_parent()
@onready var timer := $Timer
@onready var kill_area := $KillArea
@onready var radius_viewer := $RadiusViewer
@onready var col_shape := $KillArea/CollisionShape2D
@export var attack_if_provoked := true
@export var never_attack_first := false
@export var show_radius := true
@export var prog_data : ProgressionData
var target 

signal target_found(n)
signal attacked(n)
signal target_lost(n)
signal radius_changed(r:float)

func _ready() -> void:
	radius_viewer.set_visible(show_radius)

func set_type(tp:EnemyType) -> void:
	var new_radius := tp.kill_range * prog_data.get_rules(entity).kill_range_factor * Global.config.enemy_kill_range_def * Global.config.cell_size
	set_radius(new_radius)

func set_radius(r:float) -> void:
	var shp := CircleShape2D.new()
	shp.radius = r
	col_shape.shape = shp
	radius_changed.emit(r)
	radius_viewer.update(r)

func attack() -> void:
	if not get_target(): return
	if is_busy(): return
	
	
	var specific_damage_factor := 1.0
	if (entity is Enemy):
		specific_damage_factor = prog_data.get_rules().enemy_damage_factor
	
	var raw_damage : float = entity.type.damage * Global.config.enemy_damage_factor * specific_damage_factor
	var raw_shield : float = entity.type.shield * Global.config.enemy_shield_factor
	var damage : float = clamp(raw_damage - raw_shield, 0, 10000)
	
	target.health.change(-damage)
	if ("attacker" in target): target.attacker.provoke(entity)
	attacked.emit(target)
	restart_timer()

func restart_timer():
	if entity.dead: return # we died while doing our attack
	
	var specific_delay_factor := 1.0
	if (entity is Enemy): 
		specific_delay_factor = prog_data.get_rules().enemy_attack_delay_factor
	
	timer.wait_time = entity.type.attack_delay * Global.config.enemy_attack_delay_factor * specific_delay_factor
	timer.start()

func _on_timer_timeout() -> void:
	attack()

func is_busy() -> bool:
	return timer.time_left > 0

func get_target() -> Node2D:
	if target and not is_instance_valid(target): reset_target()
	return target

func set_target(t:Node2D) -> void:
	if is_busy(): return
	if not can_damage_target(t): return
	
	target = t
	target_found.emit(target)
	attack()

func reset_target() -> void:
	timer.stop()
	if target: target_lost.emit(target)
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

# @TODO @IMPROV: some cleaner code structure/module/resource/whatever to check if things can hit each other
func can_damage_target(body = target) -> bool:
	if (body is Enemy) and (entity is Enemy): return false
	if (body is Enemy) and (entity is Element):
		return body.type.is_weak_to(entity.type)
	return true
