extends MovementType
class_name MovementJump

var time_since_last_move := 0.0
var time_for_next_jump := 0.0

func update(dt: float, mover:ModuleMover) -> Vector2:
	time_since_last_move += dt
	if time_since_last_move >= time_for_next_jump:
		return jump(dt, mover)
	return Vector2.ZERO

func jump(dt:float, mover:ModuleMover) -> Vector2:
	var time_missed := time_since_last_move
	
	time_since_last_move = 0
	time_for_next_jump = Global.config.movement_jump_interval_bounds.rand_float()
	
	var vec := get_heart_focused_movement(dt, mover)
	vec *= time_missed
	return vec
