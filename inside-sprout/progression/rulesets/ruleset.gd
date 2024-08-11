extends Resource
class_name Ruleset

@export var desc := ""
@export var conversion_timer_factor := 1.0
@export var conversion_insta_finish := false

@export var speed_factor := 1.0
@export var speed_factor_enemy := 1.0
@export var speed_factor_player := 1.0

@export var elements_health_factor := 1.0
@export var element_damage_factor := 1.0

@export var drop_heal_factor := 0.0
@export var drop_regrow_hedge := false
@export var recolor_upon_entry := false

@export var wave_duration_factor := 1.0
@export var wave_unit_factor := 1.0

@export var sight_range_factor := 1.0
@export var kill_range_factor := 1.0
@export var enemy_damage_factor := 1.0
@export var enemy_attack_delay_factor := 1.0

@export var seed_spawn_speed_factor := 1.0

@export var bullet_speed_factor := 1.0
@export var bullet_damage_factor := 1.0

@export var enemy_spawn_forbidden_top := false
@export var enemy_spawn_forbidden_bottom := false

@export var enemies_drop_seeds := false
