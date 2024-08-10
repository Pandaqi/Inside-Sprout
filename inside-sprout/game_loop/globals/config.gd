extends Resource
class_name Config

@export_group("Map")
@export var map_size := Vector2i(10,10)
@export var cell_size := 256.0
@export var sprite_size := 128.0

@export_subgroup("Background")
@export var map_background_color := Color(1,1,1)
@export var map_background_layers := 5
@export var map_background_scale_per_layer := 0.15

@export_subgroup("Areas")
@export var area_min_size := 2
var area_max_size_bounds := Bounds.new(4,7)
@export var area_group_min_size := 3 # this is in CELLS, not AREAS
var area_group_max_size_bounds := Bounds.new(3,5)

@export_subgroup("Camera")
@export var camera_edge_margin := Vector2(32.0, 32.0)

@export_group("Enemies")
@export_subgroup("Spawning")
@export var waves_max := 16
var waves_strength_bounds := Bounds.new(3.0, 35.0)
var waves_duration_bounds := Bounds.new(10.0, 60.0)
var waves_time_diff_bounds := Bounds.new(0.05, 8.0) # min/max time diff between subsequent spawns
var waves_unlock_interval_bounds := Bounds.new(2, 4) # min/max waves before next type unlock
@export var waves_delay_before_start := 3 # how many seconds to keep the message on the screen before the wave eventually starts

@export_subgroup("Defaults")
@export var enemy_damage_factor := 50.0
@export var enemy_health_factor := 100.0
@export var enemy_shield_factor := 10.0
@export var enemy_attack_delay_factor := 1.0
@export var enemy_sight_range_def := 2.0 # ~cell_size
@export var enemy_kill_range_def := 0.33 # ~cell_size
var enemy_seed_drop_bounds := Bounds.new(0, 2)

@export_group("Movement")
@export var movement_speed_def := 50.0
@export var movement_speed_factor_player := 5.0
var movement_jump_interval_bounds := Bounds.new(2.5, 5.0)

@export_group("Hearts")
@export var hearts_num := 1
@export var hearts_min_cells_between := 3
@export var heart_health := 10.0 # ~enemy_damage
@export var hearts_min_cells_to_edge := 3
@export var hearts_heal_def := 0.15 # ~heart_health; how much is healed if that rule is enabled

@export_group("Elements")
@export_subgroup("Spawning")
var elements_spawn_bounds := Bounds.new(3.0, 6.0)
@export var elements_spawn_bounds_scale_per_wave := 1.05
@export var elements_spawn_min_dist_to_player := 3.0 # ~cell_size
var elements_conversion_duration_bounds := Bounds.new(2.0, 4.0)
@export var elements_spawn_extra_prob := 0.8
@export var elements_spawn_tick := 3.0
var elements_num_selected_bounds := Bounds.new(3,4)

@export_subgroup("Defaults")
@export var elements_health_factor := 50.0

@export_group("Machines")
@export_subgroup("TreeGun")
@export var gun_bullet_speed := 1.0 # ~map_size.x * cell_size; the idea is that 1/this gives time needed to traverse entire map
@export var gun_timer_duration := 2.0
@export var gun_bullet_damage := 1.0 # ~enemy_health
@export var gun_bullet_max_hits := 1
