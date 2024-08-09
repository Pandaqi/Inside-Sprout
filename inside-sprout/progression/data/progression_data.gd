extends Resource
class_name ProgressionData

@export var rules_interior : Ruleset
@export var rules_exterior : Ruleset

func get_rules(entity) -> Ruleset:
	var rs := rules_exterior
	if entity.map_tracker.is_interior(): rs = rules_interior
	return rs
