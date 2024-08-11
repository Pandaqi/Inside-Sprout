extends MovementType
class_name MovementEnemyDefault

func update(dt:float, mover:ModuleMover) -> Vector2:
	return get_heart_focused_movement(dt, mover)
