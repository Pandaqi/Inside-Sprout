extends Resource
class_name EnemyType

@export var frame := 0
@export var desc := ""
@export var strength := 1.0
@export var distractions : Array[ElementType] = []
@export var distractions_all := false
@export var movement_type : MovementType
@export var weaknesses : Array[ElementType] = []
@export var weaknesses_all := false
@export var damage := 1.0
@export var health := 1.0
@export var attack_delay := 1.0
@export var shield := 0.0

# @NOTE: spawnable elements would just create "random lucky kills" if any enemies reacted to them
func distracted_by(e:ElementType) -> bool:
	return distractions.has(e) or (distractions_all and not e.spawnable)

func is_weak_to(e:ElementType) -> bool:
	return weaknesses.has(e) or (weaknesses_all and not e.spawnable)
