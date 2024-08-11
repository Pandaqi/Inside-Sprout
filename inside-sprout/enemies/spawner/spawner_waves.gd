class_name SpawnerWaves extends Node

signal wave_started()
signal wave_ended()

var wave_index := -1
var spawn_scene : PackedScene
var enemy_data : EnemyData
var map_data : MapData
var element_data : ElementData
var wave_start_time : float
var last_spawn_time : float
var next_unlock_wave := -1
var unlock_order : Array[EnemyType] = []
var spawn_events : Array[SpawnEvent] = []
var last_unlocked_type : EnemyType = null
var prog_data : ProgressionData

func set_config(scene:PackedScene, ed:EnemyData, md:MapData, eld:ElementData, prd:ProgressionData) -> void:
	spawn_scene = scene
	enemy_data = ed
	map_data = md
	element_data = eld
	prog_data = prd
	
	enemy_data.enemy_removed.connect(on_enemy_removed)
	prepare_unlock_order()

func prepare_unlock_order() -> void:
	var all_enemies := enemy_data.all_enemies.duplicate(false)
	unlock_order = []
	
	# only include all enemies that are actually relevant to types currently selected for play
	for enemy in all_enemies:
		var distraction := false
		var weakness := false
		for dis in enemy.distractions:
			if element_data.area_types.has(dis):
				distraction = true
		
		if enemy.distractions_all:
			distraction = true
		
		for weak in enemy.weaknesses:
			if element_data.area_types.has(weakness):
				weakness = true
		
		if enemy.weaknesses_all:
			weakness = distraction
		
		if (not weakness) and (not distraction): continue
		unlock_order.append(enemy)
	
	unlock_order.shuffle()
	unlock_order.sort_custom(func(a:EnemyType, b:EnemyType):
		if a.strength < b.strength: return true
		return false
	)

func start() -> void:
	wave_index += 1
	
	if at_max_wave():
		GSignal.game_over.emit(true)
		return
	
	unlock_types_if_needed()
	generate_wave()
	
	wave_start_time = Time.get_ticks_msec()
	wave_started.emit()

func at_max_wave() -> bool:
	return wave_index >= Global.config.waves_max

func update() -> void:
	spawn_if_needed()

func end() -> void:
	wave_ended.emit()

func on_enemy_removed(_e:Enemy) -> void:
	end_wave_if_needed()

func end_wave_if_needed() -> void:
	if enemy_data.count() > 0: return
	if has_items_left_to_spawn(): return
	end()

func has_items_left_to_spawn() -> bool:
	return spawn_events.size() > 0

func spawn_if_needed() -> void:
	if not has_items_left_to_spawn(): return
	
	var should_trigger : bool = (Time.get_ticks_msec() - last_spawn_time) / 1000.0 >= spawn_events.front().time_diff
	if not should_trigger: return
	
	spawn(spawn_events.pop_front())

func get_progression_ratio() -> float:
	return wave_index / float(Global.config.waves_max - 1)

func spawn(ev:SpawnEvent) -> void:
	var e = spawn_scene.instantiate()
	
	var top_forbidden := prog_data.get_rules().enemy_spawn_forbidden_top
	var bottom_forbidden := prog_data.get_rules().enemy_spawn_forbidden_bottom
	
	e.set_position( map_data.get_random_edge_position(top_forbidden, bottom_forbidden) )
	GSignal.place_on_map.emit("entities", e)
	e.set_type(ev.type)
	enemy_data.add_enemy(e)
	e.state.died.connect(func(_enem): enemy_data.remove_enemy(e))
	e.activate()
	
	last_spawn_time = Time.get_ticks_msec()

func unlock_types_if_needed() -> void:
	last_unlocked_type = null
	if unlock_order.size() <= 0: return
	if wave_index < next_unlock_wave: return
	
	var new_type : EnemyType = unlock_order.pop_front()
	enemy_data.unlock(new_type)
	last_unlocked_type = new_type
	next_unlock_wave = wave_index + Global.config.waves_unlock_interval_bounds.rand_int()
	
	# the first few waves should just be unlocking enemies, for variety
	if wave_index < Global.config.waves_min_before_non_unlocks:
		next_unlock_wave = wave_index + 1

func generate_wave() -> void:
	var target_strength := Global.config.waves_strength_bounds.interpolate(get_progression_ratio())
	target_strength *= prog_data.get_rules().wave_unit_factor

	var cur_strength := 0.0
	spawn_events = []
	
	# ensure a newly unlocked type appears in the wave at least twice
	if Global.config.waves_ensure_new_type_appears_freq > 0 and last_unlocked_type:
		for i in range(Global.config.waves_ensure_new_type_appears_freq):
			cur_strength += last_unlocked_type.strength
			spawn_events.append(SpawnEvent.new(last_unlocked_type))
	
	# first determine all types
	while cur_strength < target_strength:
		var rand_enemy := enemy_data.get_random_available()
		cur_strength += rand_enemy.strength
		spawn_events.append(SpawnEvent.new(rand_enemy))
	spawn_events.shuffle()
	
	# then spread them randomly across the duration of the wave
	var target_duration := Global.config.waves_duration_bounds.interpolate(get_progression_ratio())
	target_duration *= prog_data.get_rules().wave_duration_factor
	
	var time_diff_bounds := Global.config.waves_time_diff_bounds
	var cur_duration := 0.0
	var spawn_events_modifiable := spawn_events.duplicate(false)
	
	# ensure a minimum time between all events
	for ev in spawn_events:
		ev.time_diff += time_diff_bounds.start
		cur_duration += ev.time_diff
	
	# then extend timers randomly until we've fit the exact length of the wave
	var time_diff_increments := 0.075 * time_diff_bounds.average()
	while cur_duration < target_duration and spawn_events_modifiable.size() > 0:
		var ev : SpawnEvent = spawn_events_modifiable.pick_random()
		var max_add : float = min(time_diff_increments, time_diff_bounds.end - ev.time_diff)
		ev.time_diff += max_add
		cur_duration += max_add
		
		var cur_ev_maxed_out := ev.time_diff >= time_diff_bounds.end
		if cur_ev_maxed_out:
			spawn_events_modifiable.erase(ev)
	
