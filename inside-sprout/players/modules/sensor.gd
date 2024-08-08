class_name ModuleSensor extends Node2D

var target : Element = null
@onready var entity : Enemy = get_parent()
@onready var area_scan := $ScanArea
@export var attacker : ModuleAttacker

signal target_found(e:Element)
signal target_lost(e:Element)

func activate() -> void:
	attacker.target_found.connect(on_attack_target_found)
	attacker.target_lost.connect(on_attack_target_lost)

func on_attack_target_found(_n:Node2D) -> void:
	reset_target()

func on_attack_target_lost(_n:Node2D) -> void:
	recheck_bodies()

func set_target_element(e:Element) -> void:
	target = e
	target_found.emit(e)

func reset_target() -> void:
	target_lost.emit(target)
	target = null

func get_target_element() -> Element:
	if target and not is_instance_valid(target): reset_target()
	return target

func recheck_bodies() -> void:
	for body in area_scan.get_overlapping_bodies():
		_on_scan_area_body_entered(body)

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
