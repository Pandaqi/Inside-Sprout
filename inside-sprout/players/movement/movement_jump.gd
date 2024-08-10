extends MovementType
class_name MovementJump

var time_since_last_move := 0.0
var time_for_next_jump := 0.0

func update(dt: float, mover:ModuleMover) -> Vector2:
	time_since_last_move += dt
	if time_since_last_move >= time_for_next_jump:
		return jump(mover)
	return Vector2.ZERO

# @TODO @IMPROV: repeated code in movement types now, but meh?
func jump(mover:ModuleMover) -> Vector2:
	var target_element := mover.sensor.get_target_element()
	var cur_pos := mover.global_position
	var target_pos := cur_pos
	if target_element:
		target_pos = target_element.global_position
	else:
		var closest_heart := mover.map_data.get_closest_heart_to(mover.global_position)
		if closest_heart:
			target_pos = closest_heart.global_position
	
	var time_missed := time_since_last_move
	
	time_since_last_move = 0
	time_for_next_jump = Global.config.movement_jump_interval_bounds.rand_float()
	
	var vec := (target_pos - cur_pos).normalized()
	return vec * speed * mover.get_speed_factor() * time_missed
