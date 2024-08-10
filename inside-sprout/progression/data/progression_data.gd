extends Resource
class_name ProgressionData

@export var all_rules : Array[Ruleset]
@export var rules_interior : Ruleset
@export var rules_exterior : Ruleset
@export var rules_default : Ruleset
var ruleset : Ruleset
var rules_interior_copy : Ruleset
var rules_exterior_copy : Ruleset

func reset() -> void:
	ruleset = rules_default.duplicate(true)
	rules_interior_copy = rules_interior.duplicate(true)
	rules_exterior_copy = rules_exterior.duplicate(true)

func get_rules(entity = null) -> Ruleset:
	var rs := rules_exterior_copy
	if entity and entity.map_tracker.is_interior(): rs = rules_interior_copy
	return rs

func merge_rulesets(target:Ruleset, original := ruleset) -> void:
	original.conversion_timer_factor *= target.conversion_timer_factor
	original.conversion_insta_finish = original.conversion_insta_finish or target.conversion_insta_finish
	
	original.speed_factor *= target.speed_factor
	original.speed_factor_enemy *= target.speed_factor_enemy
	original.speed_factor_player *= target.speed_factor_player
	original.elements_health_factor *= target.elements_health_factor
	
	original.drop_heal_factor *= target.drop_heal_factor
	original.drop_regrow_hedge = original.drop_regrow_hedge or target.drop_regrow_hedge
	original.recolor_upon_entry = original.recolor_upon_entry or target.recolor_upon_entry
	
	original.wave_duration_factor *= target.wave_duration_factor
	original.wave_unit_factor *= target.wave_unit_factor
	
	original.sight_range_factor *= target.sight_range_factor
	original.kill_range_factor *= target.kill_range_factor
	original.enemy_damage_factor *= target.enemy_damage_factor
	original.enemy_attack_delay_factor *= target.enemy_attack_delay_factor
	
	original.seed_spawn_speed_factor *= target.seed_spawn_speed_factor
	original.bullet_speed_factor *= target.bullet_speed_factor
	original.bullet_damage_factor *= target.bullet_damage_factor
	
	original.enemy_spawn_forbidden_bottom = original.enemy_spawn_forbidden_bottom or target.enemy_spawn_forbidden_bottom
	original.enemy_spawn_forbidden_top = original.enemy_spawn_forbidden_top or target.enemy_spawn_forbidden_top
	
	original.enemies_drop_seeds = original.enemies_drop_seeds or target.enemies_drop_seeds

func update_ruleset(target:Ruleset) -> void:
	merge_rulesets(target, ruleset)
	merge_rulesets(rules_interior_copy, ruleset)
	merge_rulesets(rules_exterior_copy, ruleset)
