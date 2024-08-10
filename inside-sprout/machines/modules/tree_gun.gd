extends Node2D

@export var players_data : PlayersData
@export var map_data : MapData
@export var prog_data : ProgressionData
@export var bullet_scene : PackedScene

var targets : Array[Player] = []
var area_group : MapAreaGroup
var bullets : Array[Element] = []

@onready var timer := $Timer
@onready var sprite := $SpriteArrow
@onready var prog_bar := $SpriteArrow/TextureProgressBar

func _ready() -> void:
	var cell := map_data.grid.get_cell_at( map_data.grid.real_pos_to_grid_pos(global_position) )
	area_group = cell.area.group
	
	timer.timeout.connect(on_timer_timeout)
	if area_group:
		area_group.object_entered.connect(on_object_entered)
		area_group.object_exited.connect(on_object_exited)

func on_object_entered(o) -> void:
	if (o is Player): targets.append(o)
	if (o is Element) and o.type.can_be_bullet: 
		add_bullet(o)

func on_object_exited(o) -> void:
	if (o is Player): targets.erase(o)
	if (o is Element) and bullets.has(o): 
		remove_bullet(o)

func add_bullet(b:Element) -> void:
	bullets.append(b)
	if not is_busy(): restart_timer()

func remove_bullet(b:Element) -> void:
	bullets.erase(b)
	if is_busy() and not has_bullets(): stop_timer()

func has_bullets() -> bool:
	return bullets.size() > 0

func has_target() -> bool:
	return targets.size() > 0

func _physics_process(_dt:float) -> void:
	set_visible(false) 
	if not has_target(): return
	var vec : Vector2 = (targets.front().global_position - global_position).normalized()
	set_rotation(vec.angle())
	set_visible(true)
	prog_bar.set_value( get_powerup_ratio() * 100)

func shoot() -> void:
	if not has_bullets(): return
	
	bullets.pop_back().kill()
	
	var b = bullet_scene.instantiate()
	b.global_position = sprite.global_position
	b.rotation = get_rotation()
	b.damage_factor = prog_data.get_rules().bullet_damage_factor
	GSignal.place_on_map.emit("entities", b)
	
	var base_speed := Global.config.gun_bullet_speed * Global.config.cell_size * Global.config.map_size.x
	var impulse := Vector2.from_angle(b.rotation) * base_speed
	b.velocity = impulse
	
	restart_timer()

func restart_timer() -> void:
	timer.wait_time = Global.config.gun_timer_duration * prog_data.get_rules().bullet_speed_factor
	timer.start()

func stop_timer() -> void:
	timer.stop()

func on_timer_timeout() -> void:
	shoot()

func is_busy() -> bool:
	return timer.time_left > 0

func get_powerup_ratio() -> float:
	if not is_busy(): return 1.0
	return 1.0 - timer.time_left / timer.wait_time
