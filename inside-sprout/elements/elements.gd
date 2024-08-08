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
@onready var timer := $Timer

func preactivate() -> void:
	element_data.reset()
	prepare_types()

func activate() -> void:
	GSignal.drop_element.connect(on_drop_requested)
	timer.timeout.connect(on_timer_timeout)
	on_timer_timeout()

# @TODO: for now, we just use all types, but we should probably cut it off of we start having too many
# => And then at monsters, don't include monsters without the right weaknesses/distractions of course
func prepare_types() -> void:
	var available_types := element_data.all_types.duplicate(false)
	var spawnable_types : Array[ElementType] = []
	var area_types : Array[ElementType] = []
	for type in available_types:
		if not type.spawnable: 
			area_types.append(type)
			continue
		spawnable_types.append(type)
	
	element_data.available_types = available_types
	element_data.spawnable_types = spawnable_types
	element_data.area_types = area_types

func restart_timer() -> void:
	if method != ElementSpawnMethod.AUTOMATIC: return
	timer.wait_time = Global.config.elements_spawn_tick
	timer.start()

func on_timer_timeout() -> void:
	refresh()
	restart_timer()

func refresh() -> void:
	# @TODO: scale with player count/wave/whatever
	var num_bounds := Global.config.elements_spawn_bounds
	var cur_num := element_data.count()
	if cur_num >= num_bounds.end: return
	
	while cur_num < num_bounds.start:
		spawn()
		cur_num += 1
	
	if randf() <= Global.config.elements_spawn_extra_prob:
		spawn()
		cur_num += 1

func spawn(et:ElementType = null, pos:Vector2 = Vector2.ZERO) -> void:
	var node = element_scene.instantiate()
	if pos.length() <= 0.0003:
		pos = get_random_valid_position()
	
	node.set_position(pos)
	GSignal.place_on_map.emit("entities", node)
	
	if not et: 
		et = element_data.spawnable_types.pick_random()
	
	node.set_type(et)
	
	element_data.add_element(node)
	node.died.connect(func(_no): element_data.remove_element(node))

# @TODO: also spawn away from other elements?
func get_random_valid_position() -> Vector2:
	var avoid := players_data.players.duplicate(false)
	var min_dist := Global.config.elements_spawn_min_dist_to_player * Global.config.cell_size
	var pos := map_data.query_position({ "avoid": avoid, "dist": min_dist })
	return pos

func on_drop_requested(et:ElementType, pos:Vector2) -> void:
	spawn(et, pos)
