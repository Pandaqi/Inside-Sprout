extends Resource
class_name MovementType

@export var speed := 1.0

func update(mover:ModuleMover) -> Vector2:
	if not mover.input: return Vector2.ZERO
	var vec := mover.input.get_vector()
	return speed * mover.get_speed_factor() * vec
