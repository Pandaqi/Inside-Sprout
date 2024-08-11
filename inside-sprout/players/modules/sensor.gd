class_name ModuleSensor extends Node2D

var target : Element = null
@onready var entity : Enemy = get_parent()
@onready var area_scan := $ScanArea
@onready var col_shape := $ScanArea/CollisionShape2D
@onready var radius_viewer := $RadiusViewer
@export var prog_data : ProgressionData
@export var attacker : ModuleAttacker

signal target_found(e:Element)
signal target_lost(e:Element)
signal radius_changed(r:float)

func activate() -> void:
	attacker.target_found.connect(on_attack_target_found)
	attacker.target_lost.connect(on_attack_target_lost)

func set_type(tp:EnemyType) -> void:
	var new_radius := tp.sight_range * prog_data.get_rules(entity).sight_range_factor * Global.config.enemy_sight_range_def * Global.config.cell_size
	set_radius(new_radius)

func set_radius(r:float) -> void:
	var shp := CircleShape2D.new()
	shp.radius = r
	col_shape.shape = shp
	radius_changed.emit(r)
	radius_viewer.update(r)

func on_attack_target_found(n) -> void:
	if not (n is Element): 
		reset_target()
		return
	set_target_element(n)

func on_attack_target_lost(_n) -> void:
	recheck_bodies()

func set_target_element(e:Element) -> void:
	target = e
	target_found.emit(e)

func reset_target() -> void:
	target_lost.emit(target)
	target = null
	recheck_bodies()

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
