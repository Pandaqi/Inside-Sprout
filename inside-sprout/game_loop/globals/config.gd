extends Resource
class_name Config

@export_group("Map")
@export var map_size := Vector2i(10,10)
@export var cell_size := 256.0

@export_subgroup("Background")
@export var map_background_color := Color(1,1,1)
@export var map_background_layers := 5
@export var map_background_scale_per_layer := 0.15

@export_subgroup("Areas")
@export var area_min_size := 2
var area_max_size_bounds := Bounds.new(4,7)

@export_subgroup("Camera")
@export var camera_edge_margin := Vector2(32.0, 32.0)

@export_group("Enemies")
@export_subgroup("Spawning")
@export var waves_max := 20
var waves_strength_bounds := Bounds.new(3.0, 35.0)
var waves_duration_bounds := Bounds.new(10.0, 60.0)
var waves_time_diff_bounds := Bounds.new(0.05, 8.0) # min/max time diff between subsequent spawns
var waves_unlock_interval_bounds := Bounds.new(2, 4) # min/max waves before next type unlock

@export_subgroup("Defaults")
@export var enemy_damage_factor := 50.0
@export var enemy_health_factor := 100.0

@export_group("Movement")
@export var movement_speed_def := 50.0
@export var movement_speed_factor_player := 5.0

@export_group("Hearts")
@export var hearts_num := 1
@export var hearts_min_cells_between := 4
@export var heart_health := 10.0 # ~enemy_damage

@export_group("Elements")
@export_subgroup("Spawning")
var elements_spawn_bounds := Bounds.new(3.0, 6.0)
@export var elements_spawn_min_dist_to_player := 3.0 # ~cell_size
var elements_conversion_duration_bounds := Bounds.new(2.0, 4.0)
@export var elements_spawn_extra_prob := 0.8
@export var elements_spawn_tick := 3.0
