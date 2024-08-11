class_name Elements extends Node2D

enum ElementSpawnMethod
{
	AUTOMATIC,
	PLAYER
}

@export var method := ElementSpawnMethod.AUTOMATIC
@export var element_data : ElementData
@export var map_data : MapData
@export var players_data : PlayersData
@export var element_scene : PackedScene
@export var prog_data : ProgressionData
@export var enemy_data : EnemyData
@onready var timer := $Timer

func preactivate() -> void:
	element_data.reset()
	prepare_types()

func activate() -> void:
	GSignal.drop_element.connect(on_drop_requested)
	timer.timeout.connect(on_timer_timeout)
	on_timer_timeout()

func prepare_types() -> void:
	var available_types := element_data.all_types.duplicate(false)
	var spawnable_types : Array[ElementType] = []
	var area_types : Array[ElementType] = []
	for type in available_types:
		if type.auto_area: area_types.append(type)
		if type.spawnable: spawnable_types.append(type)
	
	area_types.shuffle()
	spawnable_types.shuffle()
	
	var num_area_types := Global.config.elements_num_selected_bounds.rand_int()
	while area_types.size() > num_area_types:
		area_types.pop_back()
	
	element_data.available_types = available_types
	element_data.spawnable_types = spawnable_types
	element_data.area_types = area_types

func get_spawn_factor() -> float:
	return prog_data.get_rules().seed_spawn_speed_factor

func restart_timer() -> void:
	if method != ElementSpawnMethod.AUTOMATIC: return
	timer.wait_time = Global.config.elements_spawn_tick / get_spawn_factor()
	timer.start()

func on_timer_timeout() -> void:
	refresh()
	restart_timer()

func refresh() -> void:
	var num_bounds := Global.config.elements_spawn_bounds.clone()
	num_bounds.scale( get_spawn_factor() )
	num_bounds.scale( pow( Global.config.elements_spawn_bounds_scale_per_wave, clamp(enemy_data.spawner.wave_index + 1, 1, Global.config.waves_max)) )
	num_bounds.floor_both()

	var cur_num := element_data.count_spawnables()
	if cur_num >= num_bounds.end: return
	
	while cur_num < num_bounds.start:
		spawn()
		cur_num += 1
	
	if randf() <= Global.config.elements_spawn_extra_prob and cur_num < num_bounds.end:
		spawn()
		cur_num += 1

func spawn(et:ElementType = null, pos:Vector2 = Vector2.ZERO) -> void:
	var node : Element = element_scene.instantiate()
	if pos.length() <= 0.0003:
		pos = get_random_valid_position()
	
	node.set_position(pos)
	GSignal.place_on_map.emit("entities", node)
	
	if not et: 
		et = element_data.spawnable_types.pick_random()
	
	node.set_type(et)
	
	element_data.add_element(node)
	node.state.died.connect(func(_no): element_data.remove_element(node))
	
	node.activate()

func get_random_valid_position() -> Vector2:
	var avoid := players_data.players.duplicate(false) + element_data.get_spawnables()
	var min_dist := Global.config.elements_spawn_min_dist_to_player * Global.config.cell_size
	var pos := map_data.query_position({ "avoid": avoid, "dist": min_dist })
	return pos

func on_drop_requested(et:ElementType, pos:Vector2) -> void:
	spawn(et, pos)
